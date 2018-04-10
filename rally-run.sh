source ~/admin-openrc
rally deployment destroy
rally deployment create --fromenv --name=existing
rally task start create-and-delete-user.json

rally deployment destroy
rally deployment create --fromenv --name=existing
rally task start boot-and-delete.json

