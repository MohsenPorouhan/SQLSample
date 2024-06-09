select 
pat.APPRAISAL_TEMPLATE_ID
,pat.NAME
,pat.DATE_FROM
,pat.DATE_TO
,passt.ASSESSMENT_TYPE_ID
,passt.NAME
,passt.DATE_FROM
,passt.DATE_TO
,pass.ASSESSMENT_ID
,pass.PERSON_ID
,(select full_name from hr.per_all_people_f where person_id=pass.PERSON_ID and rownum=1)Person_Name
,pass.ASSESSMENT_TYPE_ID
,pass.ASSESSOR_PERSON_ID
,(select full_name from hr.per_all_people_f where person_id=pass.ASSESSOR_PERSON_ID and rownum=1)ASSESSOR_Name
,pass.ASSESSMENT_DATE
,pass.ASSESSMENT_PERIOD_START_DATE
,pass.ASSESSMENT_PERIOD_END_DATE
,pass.TOTAL_SCORE
,papp.APPRAISAL_ID
,papf.FULL_NAME
,papp.APPRAISAL_TEMPLATE_ID
,papp.APPRAISEE_PERSON_ID
,(select full_name from hr.per_all_people_f where person_id=papp.APPRAISEE_PERSON_ID and rownum=1)APPRAISEE_Name
,papp.APPRAISER_PERSON_ID
,(select full_name from hr.per_all_people_f where person_id=papp.APPRAISER_PERSON_ID and rownum=1)APPRAISER_Name
,papp.APPRAISAL_DATE
,papp.APPRAISAL_PERIOD_START_DATE
,papp.APPRAISAL_PERIOD_END_DATE
,papp.APPRAISAL_SYSTEM_STATUS
,papp.MAIN_APPRAISER_ID
,(select full_name from hr.per_all_people_f where person_id=papp.MAIN_APPRAISER_ID and rownum=1)MAIN_APPRAISER_Name
,papp.ASSIGNMENT_ID
,papp.PLAN_ID
,ppmp.PLAN_NAME
,ppmp.START_DATE
,ppmp.END_DATE
from 
     per_appraisals papp 
join per_assessments pass on papp.APPRAISAL_ID = pass.APPRAISAL_ID
join per_appraisal_templates pat on pat.APPRAISAL_TEMPLATE_ID = papp.APPRAISAL_TEMPLATE_ID
join per_assessment_types passt on passt.ASSESSMENT_TYPE_ID = pat.ASSESSMENT_TYPE_ID
join per_perf_mgmt_plans ppmp on ppmp.PLAN_ID = papp.PLAN_ID
join hr.per_all_assignments_f paaf on paaf.ASSIGNMENT_ID = papp.ASSIGNMENT_ID
join hr.per_all_people_f papf on papf.PERSON_ID = paaf.PERSON_ID
where 
1=1
and papp.PLAN_ID is not null