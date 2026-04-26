function addBulkBirthdays() {
    // --- ADD YOUR LIST HERE ---
    var birthdays = [
        // {name: "George's Birthday",    date: "1965-01-20"},
        {name: "Test's Birthday",   date: "1990-03-08"}
    ];

    var calendar = CalendarApp.getDefaultCalendar();

    birthdays.forEach(function(person) {
        var bdayDate = new Date(person.date);
        var title = person.name;

        // Create the annual recurring series
        var series = calendar.createAllDayEventSeries(
            title,
            bdayDate,
            CalendarApp.newRecurrence().addYearlyRule()
        );

        series.removeAllReminders();
        // 0 minutes before the start of the event
        series.addPopupReminder(0);

        Logger.log("Added: " + title);
    });

    Logger.log("Finished adding " + birthdays.length + " birthdays.");
}
