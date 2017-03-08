# Deploy your code with git
1. Create an EC2 instance using the [1_AWS.md] tutorial, we will be deploying our code to it.
2. Write down it's Public DNS hostname. 

### Server Side Steps
2. Set up our server to be a git-server by following the instructions [here](https://git-scm.com/book/en/v1/Git-on-the-Server-Setting-Up-the-Server)
    * Add one of your public keys to the list of authorized keys by 
    `me@local cat ~/.ssh/id_rsa.pub` and then adding the value you see to the list of `git@server ~/.ssh/authorized_keys`
3. Set up a server folder that will be our bare repository it will manage the source tree but not the files. 
    * I use `sudo mkdir -p /webapp/deploy.git`* to mean the place with my source tree "source tree"
4. Set up another folder which will contain our application files that we will checkout from the source tree `sudo mkdir -p/webapp/current`
5. Adjust both directories to be writeable by git. `sudo chown -R git /webapp`
6. Create a bare repository, again this will keep just the source tree information not our files. But the source tree can be used to checkout our files into a different directory
```
sudo su git
cd /webapp/deploy.git
git init --bare
```
Now you have a place where your code will be dropped.

### Local steps

5. On your me@local cd to the project you wish to deploy. I assume you have such a project and that it is already in github.
6. Add a new remote for git. I call mine deploy because this is it's purpose. Heroku for example uses "heroku" to achieve the same.
   * `git remote add deploy git@ec2-123-45-678-90.compute-1.amazonaws.com:/webapp/deploy.git`
   * Note the path /webapp/deploy.git vs webapp/deploy.git matters!. Think of it exactly as you do about directory structures on your local
   computer.
7. Let's deploy master! `git push deploy master`

### Back to the Server
8. Make your application "whole". 
   * The /webapp/deploy.git is only a bare source tree repository. 
   * `cd /webapp` && `git clone /webapp/deploy.git /webapp/current`
   * `cd /webapp/current`
   * Tadah! Your application is now here in `/webapp/current`.
 
### Refinements
   * [Use](http://toroid.org/git-website-howto) a hooks/post-receive hook to update the working tree so that your website is up tod date for you whenever you push.

### Troubleshooting
The most time is spent understanding the SSH magic and how git uses it. Set yourself up for success by adding extreme debugging for your SSH connection.
`git remote -v` and find the hostname of the connection that you wish to troubleshoot.

edit ~/.ssh/config and include a debugging line. Mine looks like this:
``` 
15 Host ec2-123-45-678-90.compute-1.amazonaws.com
16   IdentityFile ~/.ssh/id_rsa
17   User git
18   LogLevel DEBUG3

```
* We will be deploying a web application.
