<script type="text/javascript">
    if (!window.jBPMFormAPI) window.jBPMFormAPI = new jBPMFormsAPI();

    var hostURL = "http://localhost:8080/business-central/";

    var processes = new Object();

    processes["Policy Quote"] = {
        deploymentId: "org.acme.insurance:policyquote:1.0.4",
        processId: "policyquote.policyquoteprocess"
    };
    processes["HR"] = {
            deploymentId: "org.jbpm:HR:1.0",
            processId: "hiring"
    };
        
    function onsuccessShowForm(response) {
        $("#startProcessDiv").show();
        $("#startProcessAction").show();
    }

    function onerrorShowForm(response) {
        alert("Something wrong happened: " + response);
        $("#startProcessDiv").hide();
        $("#startProcessAction").hide();
        jBPMFormAPI.clearContainer("startProcessDiv")
    }

    function showStartProcessForm() {
        var process = document.getElementById("process").value;
        if (process) {
            var processInfo = processes[process];
            if (processInfo) {
                jBPMFormAPI.showStartProcessForm(hostURL, processInfo.deploymentId, processInfo.processId, "startProcessDiv", onsuccessShowForm, onerrorShowForm)
            }
        }
    }

    function onsuccessShowForm(response) {
        $("#startProcessDiv").show();
        $("#startProcessAction").show();
    }

    function onerrorShowForm(response) {
        alert("Something wrong happened: " + response);
        $("#startProcessDiv").hide();
        $("#startProcessAction").hide();
        jBPMFormAPI.clearContainer("startProcessDiv");
    }

    function startProcess() {
        var onsuccess= function(msg) {
            alert(msg);
            $("#startProcessDiv").hide();
            $("#startProcessAction").hide();
            jBPMFormAPI.clearContainer("startProcessDiv");
        }

        var onerror = function(msg) {
            alert(msg);
            $("#startProcessDiv").hide();
            $("#startProcessAction").hide();
            jBPMFormAPI.clearContainer("startProcessDiv");
        }
        jBPMFormAPI.startProcess("startProcessDiv", onsuccess, onerror);
    }
</script>
<div>
    <form class="navbar-form pull-left">
        <select name="process" id="process">
            <option value="Policy Quote" selected>Policy Quote</option>
            <option value="HR">HR</option>
        </select>
        <input type="button" class="btn" value="Show Start Form" onclick="showStartProcessForm()">
    </form>
    <div id="startProcessDiv" style="display: none; max-height: 450px; max-width: 400px; margin-left: 10px;"></div>
    <div id="startProcessAction" style="display: none; margin-left: 10px;">
        <input type="button" class="btn" value="Start Process" onclick="startProcess()">
    </div>
</div>