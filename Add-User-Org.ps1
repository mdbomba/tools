$ChefHome='\Users\chef'
$ChefAdminUser='chef'
$ChefAdminFirstName='Master'
$ChefAdminLastName='Chef'
$ChefAdminEmail='chef@kemptech.biz'
$ChefAdminUserPassword='devsecops'
$ChefAdminPEM="${ChefHome}\chef.pem'

$ChefOrgName='devops'
$ChefOrgDescription='DevOps_Organization'
$ChefOrgValidatorPEM="/home/chef/.chef/${ChefOrgName}-validator.pem"




#########################
# CREATE CHEF ADMIN USER
#########################
sudo chef-server-ctl user-create "$ChefAdminUser" "$ChefAdminFirstName" "$ChefAdminLastName" "$ChefAdminEmail" "$ChefAdminPassword" --filename "$ChefAdminPEM"
###########################
# CREATE CHEF ORGANIZATION
###########################
sudo chef-server-ctl org-create "$ChefOrgName" "$ChefOrgDescription" --association_user "$ChefAdminUser" --filename "$ChefOrgValidatorPEM"
