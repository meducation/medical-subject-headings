#2.2.1 / 2014-07-18
* [FEATURE] Headings now have forward references

#2.2.0 / 2014-07-10
* [FEATURE] Headings now have structured_entries which include semantic and lexical information

#2.1.0 / 2014-07-04
* [FEATURE] Headings matched with Wikipedia, infobox images and abstracts imported

#2.0.6 / 2014-06-26
* [BUGFIX] Match on summary links with hyphens in

#2.0.5 / 2014-06-25
* [FEATURE] Improve performance of linkify_summaries further.

#2.0.4 / 2014-06-25
* [FEATURE] tree can now linkify_summaries for all headings. Performance optimisations to make this viable.

#2.0.3 / 2014-06-25
* [FEATURE] You can now link cross-references in heading.summary by passing a block to heading.linkify_summary

#2.0.2 / 2014-06-23
* [BUGFIX] Removed duplicates in children and parents
* [BUGFIX] Added require for zlib

#2.0.1 / 2014-04-28
* [FEATURE] Load translations from static file to improve load times

#2.0.0 / 2014-04-28
* [FEATURE] Refactored to instances for future running of multiple trees

#1.3.0 / 2014-04-10
* [FEATURE] Released classifier to group and score matched headings

#1.2.2 / 2014-03-05
* [FEATURE] Optimised match_in_text to find headings much, much faster

# 1.2.1 / 2014-03-04
* [BUGFIX] Fix text matching to only use 'useful' headings

# 1.2.0 / 2014-02-27
* [FEATURE] Initial Release
