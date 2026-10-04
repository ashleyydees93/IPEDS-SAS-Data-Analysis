/*
============================================================
IPEDS Higher Education Data Analysis
Portfolio Version
============================================================

Purpose:
Analyze institutional characteristics from the Integrated
Postsecondary Education Data System (IPEDS) using SAS.

This portfolio version focuses on the IPEDS portion of the
original coursework and demonstrates:
- Custom SAS formats
- Filtering institutional data
- Frequency analysis
- Creation of derived categorical variables
- Labels and formatted reporting

Note:
This file is a cleaned portfolio adaptation of coursework.
The original assignment file remains unchanged.
============================================================
*/

libname IPEDS '~/IPEDS';

/* Use formats stored in the IPEDS library when available. */
options fmtsearch=(IPEDS);


/*============================================================
  1. Define simplified display formats
============================================================*/

proc format;
    value locale
        11-13 = 'City'
        21-23 = 'Suburb'
        31-33 = 'Town'
        41-43 = 'Rural';

    value control
        1     = 'Public'
        other = 'Private';

    value hloffer
        -3 = '{Not available}'
         1 = 'Award of less than one academic year'
         2 = 'At least 1, but less than 2 academic yrs'
         3 = "Associate's degree"
         4 = 'At least 2, but less than 4 academic yrs'
         5 = "Bachelor's degree"
         6 = 'Postbaccalaureate certificate'
         7 = "Master's degree"
         8 = "Post-master's certificate"
         9 = 'Doctoral degree';
run;


/*============================================================
  2. Carnegie Classification vs. Location
============================================================

This frequency table compares institutional Carnegie
classification with a simplified location category.

Only institutions with Carnegie profile values 1-7 and valid
location codes 11-43 are included.
============================================================*/

ods noproctitle;

title 'Carnegie Class vs. Location';

proc freq data=IPEDS.characteristics;
    where c21enprf between 1 and 7
          and locale between 11 and 43;

    tables c21enprf*locale / nocol nopercent;

    format locale locale.;
run;


/*============================================================
  3. Create a Combined Institution Type Variable
============================================================

The Type variable combines institutional control
(Public/Private) with the highest degree offered.
============================================================*/

data institutionTypes;
    set IPEDS.characteristics;

    length Type $60;

    Type = catx('-',
                put(control, control.),
                put(hloffer, hloffer.));

    label Type = 'Control & Highest Degree';
run;


/*============================================================
  4. Institution Counts by Type
============================================================

The final frequency table counts institutions within each
combined control/highest-degree category and orders the
results by frequency.
============================================================*/

title 'Institution Counts for All Types';

proc freq data=institutionTypes order=freq;
    tables Type;
run;

title;
footnote;
