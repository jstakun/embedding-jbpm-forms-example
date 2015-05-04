<script type="text/javascript">
    if (!window.jBPMFormAPI) window.jBPMFormAPI = new jBPMFormsAPI();
    var hostURL = "http://localhost:8080/business-central/";
    var tasks;
    var currentTask;
    function loadTaskList() {
        $.ajax({
                type: "GET",
                url: "http://localhost:8080/business-central/rest/task/query?potentialOwner=<%= request.getRemoteUser()%>",
                dataType: "xml",
                beforeSend: function () {
                    $("#listcontainer").html('<img src="img/loading.gif" border="0">');
                },
                success:  function (xml) {
                    tasks = new Object();

                    var table = '<table class="table table-striped" id="taskList"><tr><th>Id</th><th>Name</th><th>Status</th><th>&nbsp;</th></tr>'

                    var rows = '';

                    $(xml).find("task-summary").each(function() {

                        var task = {
                            taskId: $(this).find("id").text(),
                            name: $(this).find("name").text(),
                            status: $(this).find("status").text()
                        };

                        tasks[task.taskId] = task;

                        var row = '<tr>';
                        row += '<td style="width: 15px;">' + task.taskId + '</td>';
                        row += '<td>' + task.name + '</td>';
                        row += '<td>' + task.status + '</td>';
                        row += '<td><input type="button" class="btn" value="Show task form" onclick="showTaskForm(' + task.taskId + ')"></td>';
                        row += '</tr>';
                        rows = row + rows;
                    });

                    // if a task is being shown on the screen refresh buttons
                    if (currentTask) {
                        currentTask = tasks[currentTask.taskId];
                        showHideActions(currentTask.status);
                    }

                    table += rows + '</table>'
                    $("#listcontainer").html(table);
                },
                error: function(qXHR, textStatus, errorThrown) {
                    var html = '<div class="alert alert-block"><h4>Warning!</h4>Something wrong happened, please try to reload the task list</div>' +
                            '<a href="#" class="btn btn-success btn-large" onclick="loadTaskList();"><i class="icon-white icon-refresh"></i> Refresh task list</a>';
                    $("#listcontainer").html(html);
                }
        });
    }

    function showHideActions(status) {
        $("#claim").hide();
        $("#release").hide();
        $("#start").hide();
        $("#save").hide();
        $("#complete").hide();
        $("#taskactions").hide();
        if (status) {
            if (status == "Ready") $("#claim").show();
            if (status == "Reserved") {
                $("#release").show();
                $("#start").show();
            } if (status == "InProgress") {
                $("#release").show();
                $("#save").show();
                $("#complete").show();
            }
            $("#taskactions").show();
        }

    }

    function showTaskForm(taskId) {
        currentTask = tasks[taskId];

        var onsuccess = function() {
            $("#formcontainer").show();
            showHideActions(currentTask.status)
        }

        var onerror = function (msg) {
            alert("Error showing task form: " + msg);
            jBPMFormAPI.clearContainer("formcontainer");
            $("#formcontainer").hide();
            showHideActions();
        }

        if (currentTask) {
            jBPMFormAPI.showTaskForm(hostURL, taskId, "formcontainer", onsuccess, onerror)
        }
    }

    function defaultSuccessCallback(msg) {
        alert(msg);
        var taskId = currentTask.taskId;
        loadTaskList();
    }
    
    function defaultErrorCallback(msg) {
        alert(msg);
        jBPMFormAPI.clearContainer("formcontainer");
        $("#formcontainer").hide();
        showHideActions();
    }
    
    // This function will claim the task
    function claimTask() {
        if (currentTask) jBPMFormAPI.claimTask("formcontainer", defaultSuccessCallback, defaultErrorCallback)
    }

    // This function will start the task
    function startTask() {
        if (currentTask) jBPMFormAPI.startTask("formcontainer", defaultSuccessCallback, defaultErrorCallback)
    }

    // This function will submit the form and save the task state
    function saveTask() {
        if (currentTask) jBPMFormAPI.saveTask("formcontainer", defaultSuccessCallback, defaultErrorCallback)
    }

    // This function will release the task
    function releaseTask() {
        if (currentTask) {
            var doRelease = confirm("Are you sure that you want to release the task?");
            if (doRelease) {
                var onsuccess= function(msg) {
                    jBPMFormAPI.clearContainer("formcontainer");
                    currentTask = null;
                    $("#formcontainer").hide();
                    showHideActions();
                    loadTaskList();
                    alert(msg);
                }

                var onerror = function(msg) {
                    jBPMFormAPI.clearContainer("formcontainer");
                    currentTask = null;
                    $("#formcontainer").hide();
                    showHideActions();
                    loadTaskList();
                    alert(msg);
                }
                jBPMFormAPI.releaseTask("formcontainer", onsuccess, onerror)
            }
        }
    }

    // This function will submit the form and complete the task
    function completeTask() {
        var onsuccess= function(msg) {
            jBPMFormAPI.clearContainer("formcontainer");
            currentTask = null;
            $("#formcontainer").hide();
            showHideActions();
            loadTaskList();
            alert(msg);
        }

        var onerror = function(msg) {
            jBPMFormAPI.clearContainer("formcontainer");
            currentTask = null;
            $("#formcontainer").hide();
            showHideActions();
            loadTaskList();
            alert(msg);
        }
        if (currentTask) jBPMFormAPI.completeTask("formcontainer", onsuccess, onerror)
    }

    loadTaskList();
</script>
<div class="row">
    <div class="span12 centered-text" id="listcontainer">
    </div>
    <div class="span12 centered-text">
        <div class="row">
            <div id="formcontainer" class="col-md-12" style="display: none; max-height: 500px; max-width: 400px; margin-left: 30px;"></div>
        </div>

        <div class="row">
            <div id="taskactions" class="col-md-12" style="display: none; margin-left: 30px">
                <button type="button" class="btn btn-default" id="claim" onclick="claimTask()">Claim task</button>
                <button type="button" class="btn btn-default" id="release" onclick="releaseTask()">Release task</button>
                <button type="button" class="btn btn-default" id="start" onclick="startTask()">Start task</button>
                <button type="button" class="btn btn-default" id="save" onclick="saveTask()">Save task</button>
                <button type="button" class="btn btn-default" id="complete" onclick="completeTask()">Complete task</button>
            </div>
        </div>
    </div>
</div>
