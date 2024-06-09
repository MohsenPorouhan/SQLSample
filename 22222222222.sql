select 
sum (NUM)NUM,
--papf.PERSON_ID,
--papf.EMPLOYEE_NUMBER,
--papf.FULL_NAME,
APPRAISAL_TEMPLATE_ID,
Appraisal_Template_Name,
         plan_id,
         PLAN_NAME,
appraisal_system_status
from(
select 
COUNT (DISTINCT papf.person_id)NUM,
--papf.PERSON_ID,
--papf.EMPLOYEE_NUMBER,
--papf.FULL_NAME,
pat.APPRAISAL_TEMPLATE_ID,
pat.name Appraisal_Template_Name,
         papp.plan_id,
         ppmp.PLAN_NAME,
          decode(papp.appraisal_system_status, 'COMPLETED', 'ارزیابی شده و تایید شده',
         'PENDINGAPPR', 'ارزیابی شده و تایید نشده',
          'PLANNED', 'ارزیابی نشده',
          'ONGOING','ارزیابی نشده',
          'TRANSFER','ارزیابی نشده',
          'SAVED','ارزیابی نشده') appraisal_system_status
from
per_assessments pass join per_appraisals papp on pass.appraisal_id=papp.appraisal_id
join per_appraisal_templates pat on pat.APPRAISAL_TEMPLATE_ID=papp.APPRAISAL_TEMPLATE_ID
join hr.per_all_assignments_f paaf on paaf.ASSIGNMENT_ID = papp.ASSIGNMENT_ID
join hr.per_all_people_f papf on papf.PERSON_ID = paaf.PERSON_ID
join per_perf_mgmt_plans ppmp on ppmp.PLAN_ID = papp.PLAN_ID
where 
1=1
and pat.APPRAISAL_TEMPLATE_ID=:appraisal_template_id
and papp.PLAN_ID is not null
and (pat.DATE_FROM between paaf.EFFECTIVE_START_DATE and paaf.EFFECTIVE_END_DATE
        or pat.DATE_TO between paaf.EFFECTIVE_START_DATE and paaf.EFFECTIVE_END_DATE)
and (pat.DATE_FROM between papf.EFFECTIVE_START_DATE and papf.EFFECTIVE_END_DATE
        or pat.DATE_TO between papf.EFFECTIVE_START_DATE and papf.EFFECTIVE_END_DATE)
group by
--papf.PERSON_ID,
--papf.EMPLOYEE_NUMBER,
--papf.FULL_NAME,
pat.name,
papp.plan_id,
ppmp.PLAN_NAME,
pat.APPRAISAL_TEMPLATE_ID,
papp.appraisal_system_status
ORDER BY 
papp.plan_id,
  PAT.name ASC)
  group by 
  APPRAISAL_TEMPLATE_ID,
Appraisal_Template_Name,
         plan_id,
         PLAN_NAME,
  appraisal_system_status