# Create Azure DevOps Pipelines

To create an Azure DevOps pipeline from an existing YML file in a GitHub repository, follow these steps.

---

**Step 1:** Click New pipeline from the Pipeline section of the Azure DevOps project

![Step 1](img/NewPipeline-1.jpg)

**Step 2:** Select source as GitHub:

![Step 2](img/NewPipeline-2.jpg)

**Step 3:** Select the GitHub repository

![Step 3](img/NewPipeline-3.jpg)

**Step 4:** Select Existing Pipelines YAML file

![Step 4](img/NewPipeline-4.jpg)

**Step 5:** Select the desired pipeline

![Step 5](img/NewPipeline-5.jpg)

**Step 6:** For most cases, when the pipeline source is shown, you can just click Run and start your pipeline.  However, if you need to adjust some settings, then select More Actions and Save the file.

![Step 6](img/NewPipeline-6.jpg)

**Step 7:** Once the file saved, the pipeline can be run or renamed and put into a folder.

**Step 8:** To rename a pipeline (not the YML file), return to the Pipelines screen and click on the `More` menu on the right and select rename.

![Step 8](img/Rename-01.png)

**Step 9:** You can give the pipeline any descriptive name you choose, and can also group your pipelines into folders to make them easier to find.

![Step 9](img/Rename-02.png)


<!-- **Step 7:** If you need to adjust some setting, once the new pipeline page is shown, click the Edit button.

![Step 7](img/NewPipeline-7.jpg)

**Step 8:** This may not seem intuitive, but the detailed editor is hidden behind the "Triggers" option of the pipeline editor, so select that.

![Step 8](img/NewPipeline-8.jpg)

**Step 9:** On the detailed pipeline editor, select Variables -> Variable Groups, and link the variable groups that are needed for this pipeline.

![Step 9](img/NewPipeline-9.jpg)

**Step 10:** More than one variable group can be added to a pipeline.

![Step 10](img/NewPipeline-10.jpg)

**Step 11:** Switch to the YAML tab and update the name of the pipeline to be what is desired. Now the "Save and queue" is ready, and the pipeline can be run.

![Step 11](img/NewPipeline-11.jpg)
 -->