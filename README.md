# rhel-mssql-bootc


This is an example for installing/configuring MSSQL 2022 using image mode for RHEL. The steps are pretty simple:

1. clone the repo
2. build the image and push it to a container registry.
3. Start a RHEL 9.5(ish!) cloud instance and run the following:

   podman run --rm --privileged -v /dev:/dev -v /var/lib/containers:/var/lib/containers -v /:/target -v /root/.ssh/authorized_keys:/bootc_authorized_ssh_keys/root \
--pid=host --security-opt label=type:unconfined_t \
quay.io/[MYACCOUNT]/rhel-mssql-bootc \
bootc install to-existing-root --acknowledge-destructive --root-ssh-authorized-keys /bootc_authorized_ssh_keys/root

4. Adjust the above command as needed. This example will scrape the root ssh key and use it in the deployed container image. Feel free to get a key in a different location or user. Very soon this will be much simpler with the `system-reinstall-bootc` command
5. run the /opt/mssql_demo.sh script to populate the database, import Adventureworks, and run a basic query.
6. Now go do your own thing with this!!
