function listAllTaskLists() {
    var taskLists = Tasks.Tasklists.list().items;

    Logger.log('Available Task Lists:');
    for (var i = 0; i < taskLists.length; i++) {
        Logger.log(i + ': ' + taskLists[i].title + ' (ID: ' + taskLists[i].id + ')');
    }
}

function importTasksFromCSV() {
    // Upload your CSV to Google Drive and put the file ID here
    var fileId = '1zTADIbBtDiuGiLOsCJ5sAncgqw1dyoM6';
    var file = DriveApp.getFileById(fileId);
    var csvData = Utilities.parseCsv(file.getBlob().getDataAsString());

    // OPTION 1: Use a specific list by index (0 = first, 1 = second, etc.)
    // var taskList = Tasks.Tasklists.list().items[0]; // Change the number here

    // OPTION 2: Use a specific list by name
    var taskLists = Tasks.Tasklists.list().items;
    var taskList = taskLists.find(function(list) {
        return list.title === 'ΠΛΗΨΙ'; // Change to your list name
    });

    Logger.log('Importing to: ' + taskList.title);

    for (var i = 1; i < csvData.length; i++) { // Skip header row
        var row = csvData[i];
        var task = {
            title: row[0], // Subject
            notes: row[3], // Description
            due: row[2] ? new Date(row[2]).toISOString() : null // Due Date
        };

        Tasks.Tasks.insert(task, taskList.id);
        Logger.log('Created: ' + task.title);
    }
}
