# YML Lab 1 - Introduction

In Lab 1 we are starting with an introduction into Pipelines-as-Code with Azure DevOps by building a first, basic Pipeline using the Azure DevOps Portal.

Prerequisites:

* If you have not created an Organization and a Project in Azure DevOps, please start with the preparation tasks in the [Create an Azure DevOps Project](../../setup/1-Create-Azdo-Project.md) guide.

* If you have not installed VS Code,  please follow the instructions in the [Set up Visual Studio Code](../../setup/2-Visual-Studio-Code.md)

* If you have not created your own repository for the class based on the course materials, please follow the instructions in the [Import the Class Repository](../../setup/3-Clone-Repo.md) guide.

* If you need a custom Build Agent for some reason and have not created one yet, you can install a Build Agent on your VM or your Local Machine.  Please follow the instructions in the [Create a Custom Build Agent](../../build-agents/desktop-runner/readme.md) guide.

Exercises:

* [1.1 Create a YAML-Pipeline via GUI](#exercise-11-create-a-yaml-pipeline-via-gui)
* [1.2 Run your first pipeline](#exercise-12-run-your-first-pipeline)
* [1.3 Analyze the output](#exercise-13-analyze-the-output)
* [1.4 Use the Assistant to Add Tasks](#exercise-14-use-the-assistant-to-add-tasks)
* [1.5 Extend your Pipeline with Runtime Variables](#exercise-15-extend-your-pipeline-with-runtime-variables)
* [1.6 View the pipeline in your repository](#exercise-16-view-the-pipeline-in-your-repository)

---

## Exercise 1.1: Create a YAML-Pipeline via GUI

### Import our Repository from GitHub

Before we can start building our first pipeline, we need a Repository in Azure DevOps.

> **What are Azure Repos?**  
> Azure Repos are a set of version control tools that you can use to manage your code. Whether your software project is large or small, using version control as soon as possible is a good idea.
> Version control systems are software that help you track changes you make in your code over time. As you edit your code, you tell the version control system to take a snapshot of your files. The version control system saves that snapshot permanently so you can recall it later if you need it. Use version control to save your work and coordinate code changes across your team.  Goto [learn.microsoft.com/en-us/azure/devops/repos/get-started](https://learn.microsoft.com/en-us/azure/devops/repos/get-started/what-is-repos) to learn more.

1. To initialize the default repository in our DevOps Project, click on **Repos** -> **Files** and select **Import a repository**

    ![Import Repository](img/010_import_repo.png)

1. We are now importing the Lab Repository from GitHub:

    ![Import a Git repository](img/020_import_a_git_repository.png)

    **Settings:**

    * Repository type: Git
    * Clone URL: `https://github.com/lluppesms/activate.cicd.course.git`
    * Name: azdo.cicd.course

1. And click on `Import`.

    ![Import Repository](img/030_import_repository.png)

This will now import the whole public Repository from GitHub into your new Azure DevOps Repository.  We will use some of those components in the following labs.

---

### Create a Starter pipeline

Lets now get started with creating our starter pipeline.

1. Click on `Pipelines` -> `Pipelines` -> `Create Pipeline`. This will open the `Where is your code?` dialog.

1. In the `Where is your code?` section, click `Azure Repos Git (YAML)

1. In the `Select a repository` section, select `cicd.course` (or whatever name you selected for your DevOps project).

1. In the `Configure your pipeline` section, select `Starter pipeline`

    This will now create a new basic YAML-based pipeline for you that looks like this:

    ![Review your pipeline](img/040_review_your_pipeline.png)

What you can see above is a very simple pipeline that contains only a few pieces. Let's quickly go through the items we can see there:

* **trigger** define which changes or actions will trigger our current pipeline. We will cover triggers in more detail in one of the next labs.
* **pool** defines the setup of our build agent that is used to run our pipeline. You can configure things like managed or unmanaged agents, the operating system and other things.
* The **steps** section contains one or more tasks.
* **script** is an alias for a script task that can execute bash commands and scripts.

Our complete pipeline is defined in YAML. To learn the basics of YAML, see [Learn YAML in Y Minutes](https://learnxinyminutes.com/docs/yaml/). Please keep in mind that Azure Pipelines does not support all YAML features today. Unsupported features include anchors, complex keys, and sets.

For each of the new pipelines we create, remember to change the trigger to be none so that it only runs on demand during our labs.

```yml
trigger: none
```

If you are using the built-in Microsoft hosted pools for this class, you can just accept the defaults.  If you have created a custom build agent, you will need to modify the pipeline by changing the pool name to match the name of your custom agent pool.

```yml
pool:
  vmimage: ubuntu-latest
```

---

## Exercise 1.2: Run your first pipeline

Now that we have created our very first `Starter pipeline`

1. Click `Save` from the more menu (NOT `Save and run`)  to save the pipeline in your repository. This will ask you for a `Commit message` to describe your change in your repository:

![Save and Run](img/050_save_and_run.png)

Select the following options:

* Commit message: `<your commit message>`
* Optional extended description: `<additional description>`
* Commit directly to the main branch
* Click on Save

You can also select if you want to write your change into the main branch or if you want to create another branch for your change. In real world scenarios changes are almost never made directly on the main branch, and we would create additional branches based off of main for things like adding feature, fixing a bug etc., but for the purposes of this class, committing directly to the main branch is fine.

One of the idiosyncrasies of Azure DevOps is when you save a pipeline from the online editor, it names it the same as your repository where you created it.  Each time we create a new pipeline in this class, we should save it first before running it the first time, and then rename it to something meaningful.

So -- let's rename the pipeline first, and put it into a pipeline folder with your name on it:

* Click on the button with the three dots

![More Options](img/052_more_options_button.png)

* Select `Rename/move`
* Call it `<yourName> Basic Pipeline`
* Change the folder to `<yourName>`

![rename pipeline](img/054_rename_pipeline.png)

* Click `Save`

Our pipeline was now renamed and is now easier to find.  Click on the `Run pipeline` button and then `Run` to run the pipeline.  You should be taken to the pipeline running job screen where you can see the outputs.

<!-- 
> **What is a Branch?**  
> Branches are lightweight references that keep a history of commits and provide a way to isolate changes for a feature or a bug fix from your main branch and other work. Committing changes to a branch doesn't affect other branches. You can push and share branches with other people on your team without having to merge the changes into main.  
> To learn more about branches, see [Start Using Azure Repos](https://learn.microsoft.com/en-us/azure/devops/repos/get-started/). 
-->

In some cases, you may notice that your job is stuck queueing, which is probably because it is waiting for permission to use the new agent pool or the service connection. You might see this message (but you might not see it until you refresh the page).  Either way, click on the Job, then you should see a prompt asking for permissions if needed:

![Pipeline Output](img/062-first-run-01.png)

Authorize the pool and you should be ready to go

![Pipeline Output](img/064-first-run-02.png)

The pipeline will now start and after a few seconds the output should look like this:

![Pipeline Output](img/060_pipeline_output.png)

This is the summary of a specific pipeline run. You can come back at any time to lookup the status and the output of a specific pipeline run.

---

## Exercise 1.3: Analyze the output

The previously created pipeline was very basic. It does not contain much more than a one-line script that prints out `Hello World` and a multi-line script that prints out two lines with very basic echo commands.

Let's now have a deeper look into the output of your pipeline.

1. Click on `Pipelines` > `Pipelines`
1. Click on your pipeline in `Recently run pipelines`

    ![Recently run pipelines](img/070_recently_run_pipelines.png)

    In this dialog you'll now see all runs of your selected pipeline.

1. Select the last pipeline run

    Here you'll now see the details of the last pipeline run:

    ![Last pipeline run with comments](img/080_last_pipeline_run_with_comments.png)

    This dialog shows you some important information, like:

    1. Who or what triggered the pipeline
    2. The branch (in this case - main)
    3. Start date/time
    4. Duration
    5. Jobs and their status

    To get even more insights about the jobs,

1. click on `Job`

    in the `Jobs` section. This will bring you to the job details:

    ![Pipeline Output](img/090_job_output.png)

    Here you can now get deeper insights into each individual job and their tasks and steps.

1. Click on `View raw log` to view the complete logs.

    ![Repos and Files](img/100_view_raw_logs.png)

---

## Exercise 1.4: Use the Assistant to Add Tasks

Now that we have a better understanding of where to find what, we are going to extend our pipeline a bit.

1. Click `Pipelines` -> `Pipelines` -> Select your pipeline -> Click on `Edit` (top right)

    This will bring us back to the pipeline editor we've seen before.

    To get a better understanding of how to work with tasks and how to extend your pipeline, we're now going to add a third `bash` task to our pipeline.

1. Put your cursor at the end of the pipeline

1. If the Tasks list is not shown, click on the `Show assistant` link in the upper right
    ![Tasks - Search for Bash](img/110_show_assistant.png)

1. Search in the `Tasks` section for `bash`

    ![Tasks - Search for Bash](img/120_tasks_search_for_bash.png)

1. Click on `Command Line`
   * Modify the `Script` section with a new comment

    ![Bash Task](img/130_bash_task_greetings.png)

1. Click on `Add`

    We can now see that there was a new section added to our YML pipeline:

    ![New Section in Pipeline](img/140_new_bash_task_in_editor.png)

    > Note: You may experience indentation errors marked by red and yellow lines. Use the backspace option to correct the indentation until the red and yellow lines are gone.

1. Click on `Save` (top right) to save your changes

    Specify a `Commit message` and an optional extended description, select `Commit directly to the main branch` and click Save.  Our changes were now saved into our Repository (main branch) and you can now click `Run` (top right) to run the modified pipeline

    ![Run pipeline](img/150_run_pipeline.png)

1. You can now (as learned previously) have a deeper look into the job output to make sure that our new bash task works as expected:

    ![Bash task](img/160_bash_task.png)

    ![Bash task output](img/170_bash_task_output.png)

---

## Exercise 1.5: Extend your Pipeline with Runtime Variables

In our next step, we now want to make our pipeline a bit more dynamic and flexible, to achieve this we start working with runtime variables instead of using hardcoded values.

> **What is a variable?**  
> Variables give you a convenient way to get key bits of data into various parts of the pipeline. As the name suggests, the value of a variable may change from run to run or job to job of your pipeline. Almost any place where a pipeline requires a text string or a number, you can use a variable instead of hard-coding a value. The system will replace the variable with its current value during the pipeline's execution.  
> See [Pipeline Variables](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/variables) to learn more.

There are several ways to store and call variables. We are starting with a very simple way. We store our variable in our pipeline.

1. Goto `Pipelines` -> `Pipelines` -> Select your Pipeline and click on `Edit`
1. Click on `Variables` (top right)

    ![Add new variable](img/180_add_new_variable.png)

1. Click on `New variable`
1. Specify Name: `variable1`
1. Specify Value: `this comes from a pipeline variable`

    ![Create a new variable](img/190_create_new_variable.png)

    You can also specify a few more things, but for now we leave everything as it is.

1. Click on `OK` to save our new variable, and then click `Save` to save the modified pipeline variables

1. Let's now modify our pipeline to leverage the newly created variable.

1. Add a new line after 'Greetings friends!'

    ```yml
    echo 'Variable: $(variable1)'
    ```

    Your pipeline should now look like this:

    ![Add variable to pipeline](img/200_use_variable_in_pipeline.png)

    Let's now save and run our pipeline to see the changes in action:

1. Click `Save` (top right), default to `Commit directly to the main branch`, then click `Save`
1. Click `Run` (top right), default to running pipeline on `main`, then click `Run`

1. Once the pipeline runs, you should be able to see the value of your variable in the pipeline outputs:

    ![Variable in pipeline output](img/210_variable_in_pipeline_output.png)

---

## Exercise 1.6: View the pipeline in your repository

In all our previous steps we have always modified our pipeline in the `Pipelines` > `Pipelines` section using the Pipeline Editor within our browser, but that is not the only way. One of the benefits of using a YAML-based pipeline is that it is stored within an Azure Repo.

Let's look at our Pipeline in our Azure Repo:

1. Click on `Repos` -> `Files`

    You should now see a file called `azure-pipelines.yml` in your repository root directory:

    You can edit the pipeline here, too, but without the additional capabilities of the Pipeline Editor like adding tasks for example that we saw before:

    ![File Editor](img/230_repo_file_editor.png)

<!-- ------------------------------------------------------------------------------------------ -->
---

This completes Lab 1.

[Next Lab](../02_Stages/readme.md) | [Table of Contents](./readme.md)
