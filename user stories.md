% Worklog User Stories

# Creating worklog

As a User, at any time, I want to create a worklog for any subject, so that I'll have the time spent for the subject recoded.

Main success scenario

1. The user starts the command-line interface, requests the `new` command, and provides `title` and `author` parameters of the new worklog (`worklog new [SUBJECT] [AUTHOR]`).
2. The system creates worklog file with provided parameters in the working directory.

The new worklog file content

```ruby
title  "Worklog"
author "nvoynov"
date_format "%Y-%m-%d"
hourly_rate 20

track "2021-07-16", spent: "1h", desc: "creating worklog"
```

# Logging time

As a User, at any time, I want to record time spent on my tasks, so that I'll have all my efforts recorded. I want to have written down the day, time spent, and task description.

## DSL

I want to record day logged time by adding appropriate text to my worklog. I think it will be convenient enough write straight into the file without any functions from the system side.

## Special hourly rate

I want to have the ability to specify the special hourly rate when I work overtime.

## Multiple tracks per day

I want to have the ability to log several record for one day and by different hourly rates. It must be calculated together by unique date in reporting and combine work descriptions.

```ruby
on "2021-07-16", spent: "4h30m", desc: "working on user stories"
on "2021-07-16", spent: "2h30m", desc: "working on crawling use case"
on "2021-07-16", spent: "2h30m", desc: "working on crawling use case", special_rate: 30
```

## Multiple files per subject

I want to have several worklogs for single subject, so that I can keep worklog by months

# Getting report

As a User, at any time, I want to get reports based on worklogs, so that I can check my total hours and provide reports for my employer or customers.

## Base report

I want to have a verbose report at the beginning that will have such

## Specifying time period

When I request the report, I want to specify a period of time for the report in some convenient for me manner like "this week", "this month", "pervious month", etc. I want to have "this month" period by default.

## Specifying subject

When I work for several projects, I want to request the report for all subjects, or for chosen subject.

```markdown
% Nikolay's timesheet for November 2021

Project | Date       | Hours  | Rate | Description
------- | ---------- | ------ | ---- | -----------
Audit   | 2021-07-16 | 6h 30m |   20 | working on user stories
Audit   | 2021-07-17 | 8h 00m |   20 | working on user stories

Total: 14h 30m, $290
```

## Grouping and subtotals

When I request a report, I want to have the ability to specify data grouping

# Exporting reports

As a User, at any time, I want to export requested reports in a file to send it through the Internet next, so that I can provide reports for my employer and customers. I want "txt" and "csv" formats to be supported.
