Welcome to the Flyway_PoC_Onboarding wiki!

# 1. Prerequisites
> Install a Git client ([Git](https://git-scm.com/downloads), [GitHub Desktop](https://circleci.com/integrations/github), [Sourcetree](https://www.sourcetreeapp.com/))

> Determine what CICD system (Azure DevOps, Jenkins, GitLab...) your organization uses.

> I'll be using AzureDevOps (ADO) in this Demo, but the processes and steps used here would work in any setup 😉.

[If your organization dont have a CICD system, ADO offers a free tier](https://docs.microsoft.com/en-us/azure/devops/server/download/azuredevopsserver?view=azure-devops)

# 2. Preparing the PoC Environment

**Step 2.1**
[Access the URL with latest Redgate products](https://www.red-gate.com/products/redgate-deploy/entrypage/latest-installer)

**Step 2.2**
Download and Install 'Flyway Desktop', from the 'Version Control and Deployment Automation' option
![image](https://user-images.githubusercontent.com/61766198/173260012-ffb31e1a-636d-44aa-991c-d149cf2f7772.png)

![image](https://user-images.githubusercontent.com/61766198/173260631-49e42e62-3c5d-490a-9170-fec7fb7a0c17.png)

**Step 2.3**
[In SSMS, create the databases that will be used in the PoC, link to example](https://github.com/leganderson-dev/Flyway_PoC_Onboarding/blob/main/SQL%20Scripts/CreatePoCDatabases.sql)

**Step 2.4**
> Create a new project in your CICD system    -    I've called mine Flyway_PoC (Later on this name will be referred as a pipeline variable, if you want to use a different name, take note of it)

> Clone (copy) your remote repository into your local development workspace (i.e. your laptop)

# 3. Create your Flyway database Project
**Step 3.1**
Open Flyway Desktop

**Step 3.2**
Create a New Project
> Project location: _file location that you cloned your repository to_

> Project name: _any meaningful name, usually the name of your database_

> Database engine: _we will use SQL Server_

**Step 3.3**
Link Development database to the project
> This is the database that we (as developers) will use to make and validate our changes, before those get committed to source control

> We will link the Widget_Dev database

**Step 3.4**
Create your 'Schema Model'
> When we create a new DB project, the first comparison will prompt you to save all existing database objects into your schema model, thus creating a file representation of your database

> Select all objects and click 'save to project'

> Future comparisons will only show the objects that are different from your model

**Step 3.5**
Set up the shadow database
> Click on 'Generate Migrations' and then in 'Set up Shadow Database'

> We will link the Widget_Shadow database

> [Learn more about Shadow Databases](https://documentation.red-gate.com/fd/shadow-database-or-shadow-schema-138347147.html)

**Step 3.6**
Create the Baseline
> Click on 'Create Baseline' and then on 'Connect to Database'

> We will use Widget_Staging DB to create the baseline script

> Save the baseline file

> The baseline is a file that represents your production database. It contains the 'create statement' for all its objects

> No changes are made to the database when creating the baseline, so when onboarding an actual project, it is OK to point it to production or a copy of it that is the same schema version.

**Step 3.7**
Commit and Push changes to Repository
> To enable the auto generation of rollback scripts, click on the 'cog'/'settings' icon on the top right and check the 'generate undo scripts' option

![image](https://user-images.githubusercontent.com/61766198/173267939-a9b15133-fd77-4fc0-8733-aa02e5ac685d.png)


> Click on the 'Commit changes' button, or alternatively go to the 'Version Control' tab in order to do it.

> Write a relevant comment and press 'Commit'

> 'Push' changed to the remote repository and explore/browse it

# 4. Validate your project

> 4.1. In SSMS, Make a change to the dev database

> 4.2. In Flyway, go the 'Schema Model' tab and 'refresh' your project

> 4.3. Save your changes to the schema model

> 4.4. 'Generate migrations' for the changes you have made

> 4.5. 'Commit' and 'Push' changes to the remote repo

> 4.6. Go to your repo and check both the 'schema model' and 'migrations' folders to make sure your changes are as expected

# 5. Create and Configure a CI pipeline (using Classic Editor)
**Step 5.1** 
Create a new pipeline
> Click on 'Pipelines' and 'New Pipeline'

> Click on 'Use the Classic Editor'

> 'Continue'

> 'Empty Job'

**Step 5.2**
Select / Configure an 'Agent Pool'
> If your organization already uses ADO, select an 'Agent Pool' that will have access to the servers/databases that we want to deploy to

> If your organization does not have an agent, we will need to create/configure one

> [More on Azure Pipeline Agents](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/agents?view=azure-devops&tabs=browser)

> [Creating a Self-Hosted Agent](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops#permissions)

> [Wiki to Step-by-Step](https://github.com/leganderson-dev/Flyway_PoC_Onboarding/wiki/Step-by-Step-create-a-self-Hosted-Agent)

**Step 5.3**
Create a build validation task

> Click on '+' to add a new task to your job

> On the search bar, type 'Command line', click and add the 'command line' task

> Click on '+' to add a new task to your job

> On the search bar, type 'Publish build Artifacts', click and add the 'Publish build Artifacts' task

**Step 5.4**
Edit the 'Command Line' Task

> Re-name your task to something relevant, i.e. 'Build Validation Process' 

> Paste the following into the script section:

`flyway clean migrate info -url=jdbc:sqlserver://$(var_servername);$(var_buildDB);$(var_trustcertificate);$(var_integratedSecurity) -locations=filesystem:$(Build.Repository.LocalPath)/*/migrations -user=$(var_username) -password=$(var_password)`

![image](https://user-images.githubusercontent.com/61766198/173345988-c1d138b2-b5d7-4bb8-aa0c-17f6f485680c.png)

**Step 5.5**
Edit the 'Publish Artifact' task

> Paste the following into the 'Path to Publish'

`$(Build.Repository.LocalPath)/`

> Rename the 'Artifact Name'

> BuildArtifact

**Step 5.6**
Create Pipeline Variables

> Add the following pipeline variables

> _name / value_
> 1. var_buildDB / `database=widget_build`
> 2. var_integratedSecurity / `integratedSecurity=true`
> 3. var_password / `your password`
> 4. var_servername / `name of the server hosting the build DB`
> 5. var_trustcertificate / `trustservercertificate=true`
> 6. var_username / `user connecting/Making changes to the DB`

![image](https://user-images.githubusercontent.com/61766198/173346708-621abdef-5b58-4150-a284-7a70c2baa9aa.png)

**Step 5.7**
Cross your fingers

**Step 5.8**
Save and Queue


# 6. Create and Configure a Release Pipeline
**Step 6.1**
Click on 'Releases' and 'New Pipeline'

**Step 6.2**
Click on 'Empty Job'

**Step 6.3**
Click on the 'Artifacts' box and 'Add' your CI pipeline from the dropdown

**Step 6.4**
Click on the 'Stage 1' box and rename it to 'Staging' (or anything else more relevant to you)

**Step 6.5**
Create the Staging tasks

> Click on the '1 job, 0 task' link

> On the 'Agent Job' section, select the appropriate 'Agent Pool'

> Add ('+') the 'Command Line' task twice

**Step 6.6**
Configure a Staging task that creates a DryRun script

> Re-name the first task to something relevant, i.e. 'Create Deployment Script (Dryrun)'

> Paste the following code into the 'script' box
`flyway migrate -url=jdbc:sqlserver://$(var_servername);$(var_stagingDB);$(var_securitysettings) -locations=filesystem:$(System.DefaultWorkingDirectory)\_$(var_buildpipelinename)\BuildArtifact\*\migrations -dryRunOutput="$(Reportpath)\Staging\$(Release.ReleaseName)_dryrun.sql"  $(var_baselineonmigrate) $(var_username) -password=$(var_password)`

**Step 6.7**
Configure a Staging task that deploy changes to the Staging DB

> Re-name the first task to something relevant, i.e. 'Deploy to Staging DB'

> Paste the following code into the 'script' box

`flyway migrate -url=jdbc:sqlserver://$(var_servername);$(var_stagingDB);$(var_securitysettings) -locations=filesystem:$(System.DefaultWorkingDirectory)\_$(var_buildpipelinename)\BuildArtifact\*\migrations $(var_baselineonmigrate) $(var_username) -password=$(var_password)`

**Step 6.8**
Create Pipeline Variables

> Add the following pipeline variables

> _name / value_
> 1. var_baselineonmigrate / `-baselineOnMigrate=true`
> 2. var_buildpipelinename / `Flyway_PoC-CI`
> 3. var_password / `your password`
> 4. var_reportpath / `Path to a folder that will hold the dryrun script`
> 5. var_securitysettings / `trustservercertificate=true;integratedSecurity=true`
> 6. var_servername / `name of the server hosting the build DB`
> 7. var_stagingDB / `database=Widget_Staging`
> 8. var_username / `-user=redgate`

![image](https://user-images.githubusercontent.com/61766198/173359483-19a4937e-8dac-4803-873e-ba9b5b6fc779.png)

**Step 6.9**
Cross your fingers

**Step 6.10**
'Save' and 'Release'

# 7. Validate de process end-to-end


> 7.1. In SSMS, Make a change to the dev database

> 7.2. In Flyway, go the 'Schema Model' tab and 'refresh' your project

> 7.3. Save your changes to the schema model

> 7.4. 'Generate migrations' for the changes you have made

> 7.5. 'Commit' and 'Push' changes to the remote repo

> 7.6. Go to your repo and check both the 'schema model' and 'migrations' folders to make sure your changes are as expected

> 7.7 Click into your CI pipeline and 'Run Pipeline'

> 7.8 Click into your Release Pipeline and 'Create Release'

> 7.9 Validate that the changes you have made were successfully deployed to Staging
