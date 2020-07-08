let Prelude = https://prelude.dhall-lang.org/package.dhall

let JSON =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/8098184d17c3aecc82674a7b874077a7641be05a/Prelude/JSON/package.dhall sha256:0c3c40a63108f2e6ad59f23b789c18eb484d0e9aebc9416c5a4f338c6753084b

let map = https://prelude.dhall-lang.org/List/map
{- Our resource models -}
let Principal = < ServicePrincipal : Text >

let Principal/toJSON
    : Principal → JSON.Type
    = λ(p : Principal) →
        merge
          { ServicePrincipal =
              λ(svc : Text) →
                JSON.object (toMap { ServicePrincipal = JSON.string svc })
          }
          p

let Effect = < Allow | Deny >

let Effect/toJSON
    : Effect → JSON.Type
    = λ(effect : Effect) →
        merge { Allow = JSON.string "Allow", Deny = JSON.string "Deny" } effect

let Action = < STSAssumeRole >

let Action/toJSON
    : Action → JSON.Type
    = λ(action : Action) →
        merge { STSAssumeRole = JSON.string "sts:AssumeRole" } action

let RolePolicyStatement
    : Type
    = { Effect : Effect, Principal : Principal, Action : Action }

let RolePolicyStatement/toJSON
    : RolePolicyStatement → JSON.Type
    = λ(stmt : RolePolicyStatement) →
        JSON.object
          ( toMap
              { Effect = Effect/toJSON stmt.Effect
              , Principal = Principal/toJSON stmt.Principal
              , Action = Action/toJSON stmt.Action
              }
          )

let RolePolicyStatement/allowAssumeService
    : Text → RolePolicyStatement
    = λ(svc : Text) →
        { Effect = Effect.Allow
        , Action = Action.STSAssumeRole
        , Principal = Principal.ServicePrincipal svc
        }

let Version = { Type = { versionString : Text } }

let Version/toJSON
    : Version.Type → JSON.Type
    = λ(version : Version.Type) → JSON.string version.versionString

let Version20121017
    : Version.Type
    = { versionString = "2012-10-17" }

let RolePolicy =
      { Type = { Version : Version.Type, Statement : List RolePolicyStatement }
      , default =
        { Version = Version20121017, Statement = [] : List RolePolicyStatement }
      }

let RolePolicy/toJSON
    : RolePolicy.Type → JSON.Type
    = λ(rp : RolePolicy.Type) →
        JSON.object
          ( toMap
              { Version = Version/toJSON rp.Version
              , Statements =
                  JSON.array
                    ( map
                        RolePolicyStatement
                        JSON.Type
                        RolePolicyStatement/toJSON
                        rp.Statement
                    )
              }
          )

let RolePolicy/allowAssumeAwsService
    : Text → RolePolicy.Type
    = λ(awsServiceName : Text) →
        RolePolicy::{
        , Statement = [ RolePolicyStatement/allowAssumeService awsServiceName ]
        }

let AwsProvider =
      https://raw.githubusercontent.com/mujx/dhall-terraform/99a96658642aef74f0b01c0da73f2c9a07171f52/lib/aws/provider/provider.dhall

let AwsIamRole =
      https://raw.githubusercontent.com/mujx/dhall-terraform/99a96658642aef74f0b01c0da73f2c9a07171f52/lib/aws/resources/aws_iam_role.dhall

let AwsIamRolePolicyAttachment =
      https://raw.githubusercontent.com/mujx/dhall-terraform/99a96658642aef74f0b01c0da73f2c9a07171f52/lib/aws/resources/aws_iam_policy_attachment.dhall


{- Wrapper around TF resources -}
let Resource
    : Type → Type
    = λ(a : Type) → { mapKey : Text, mapValue : a }

let Resource/define
    : ∀(a : Type) → Text → a → Resource a
    = λ(a : Type) → λ(name : Text) → λ(body : a) → JSON.keyValue a name body

let Resource/AwsIamRole = Resource/define AwsIamRole.Type

let Resource/AwsIamRolePolicyAttachment =
      Resource/define AwsIamRolePolicyAttachment.Type

let Resource/AwsProvider = Resource/define AwsProvider.Type

{- Resource Descriptions -}
let Role/attachAwsArnRolePolicy
    : Text → Resource AwsIamRole.Type → Resource AwsIamRolePolicyAttachment.Type
    = λ(arn : Text) →
      λ(role : Resource AwsIamRole.Type) →
        Resource/AwsIamRolePolicyAttachment
          "${role.mapKey}-${arn}"
          AwsIamRolePolicyAttachment::{
          , name = "${arn}"
          , policy_arn = "arn:aws:iam::aws:policy/${arn}"
          , roles = Some [ "\${aws_iam_role.${role.mapKey}.name}" ]
          }

let eks_cluster_role =
      Resource/AwsIamRole
        "eks_cluster_role"
        AwsIamRole::{
        , name = Some "aws_role_eks_cluster"
        , assume_role_policy =
            JSON.render
              ( RolePolicy/toJSON
                  (RolePolicy/allowAssumeAwsService "eks.amazonaws.com")
              )
        }

let eks_nodes_role =
      Resource/AwsIamRole
        "eks_nodes_role"
        AwsIamRole::{
        , name = Some "aws_role_eks_node_group"
        , assume_role_policy =
            JSON.render
              ( RolePolicy/toJSON
                  (RolePolicy/allowAssumeAwsService "ec2.amazonaws.com")
              )
        }

let Context = { Type = { defaultRegion : Text } }

let awsProvider =
      λ(ctx : Context.Type) →
        Resource/AwsProvider
          "aws"
          AwsProvider::{ region = ctx.defaultRegion, version = Some "2.34.0" }

let Result =
      { Type =
          { provider : List (Resource AwsProvider.Type)
          , resource :
              { aws_iam_role : List (Resource AwsIamRole.Type)
              , aws_iam_role_policy_attachment :
                  List (Resource AwsIamRolePolicyAttachment.Type)
              }
          }
      , default =
        { provider = [] : List (Resource AwsProvider.Type)
        , resource =
          { aws_iam_role = [] : List (Resource AwsIamRole.Type)
          , aws_iam_role_policy_attachment =
              [] : List (Resource AwsIamRolePolicyAttachment.Type)
          }
        }
      }

let result
    : Context.Type → Result.Type
    = λ(ctx : Context.Type) →
        Result::{
        , provider = [ awsProvider ctx ]
        , resource =
          { aws_iam_role = [ eks_nodes_role, eks_cluster_role ]
          , aws_iam_role_policy_attachment =
            [ Role/attachAwsArnRolePolicy
                "AmazonEKSClusterPolicy"
                eks_cluster_role
            , Role/attachAwsArnRolePolicy
                "AmazonEKSServicePolicy"
                eks_cluster_role
            , Role/attachAwsArnRolePolicy
                "AmazonEKSWorkerNodePolicy"
                eks_nodes_role
            , Role/attachAwsArnRolePolicy "AmazonEKS_CNI_Policy" eks_nodes_role
            , Role/attachAwsArnRolePolicy
                "AmazonEC2ContainerRegistryReadOnly"
                eks_nodes_role
            ]
          }
        }

in  result
