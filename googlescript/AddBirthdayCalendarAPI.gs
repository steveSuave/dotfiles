/**
 * Bulk adds birthdays with a 9:00 AM notification.
 * Uses the Advanced Calendar Service to override default reminders.
 */
function bulkAddBirthdaysCalendarAPI() {
    // For unknown years, use the current year (e.g., "2026").
    var birthdays = [
        // {name: "George's Birthday",  date: "2026-11-03"}, // Year unknown
        {name: "Test's Birthday",    date: "1965-03-08"}
    ];

    var calendarId = 'primary';

    birthdays.forEach(function(person) {
        var event = {
            summary: person.name,
            start: { date: person.date },
            end: { date: person.date },
            recurrence: ["RRULE:FREQ=YEARLY"],
            reminders: {
                useDefault: false,
                overrides: [
                    // 0 minutes before the start of the event
                    { method: 'popup', minutes: 0 }
                ]
            }
        };

        try {
            Calendar.Events.insert(event, calendarId);
            Logger.log('Successfully added: ' + person.name);
        } catch (e) {
            Logger.log('Failed to add ' + person.name + ': ' + e.message);
        }
    });

    Logger.log('Finished processing all birthdays.');
}
