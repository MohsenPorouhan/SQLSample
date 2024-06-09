/* Formatted on 16/02/2021 02:54:28 ب.ظ (QP5 v5.287) */
select 
COUNT (DISTINCT person_id)NUM,
ASSESSMENT_NAME,
plan_id,
appraisal_system_status,
TEAM_NAME,
BU_NAME
from(
  SELECT 
--         COUNT (DISTINCT ppf.person_id)NUM,
ppf.person_id,
         ppmp.PLAN_NAME ASSESSMENT_NAME,
         papp.plan_id,
         decode(papp.appraisal_system_status, 'COMPLETED', 'ارزیابی شده و تایید شده',
         'PENDINGAPPR', 'ارزیابی شده و تایید نشده',
          'PLANNED', 'ارزیابی نشده',
          'ONGOING','ارزیابی نشده',
          'TRANSFER','ارزیابی نشده',
          'SAVED','ارزیابی نشده') appraisal_system_status,
         hou.name TEAM_NAME,
         (SELECT   
--         PAAF.PERSON_ID,
   --HOU.ORGANIZATION_ID ORG_ID,
       HOU.NAME
  FROM  
         HR_ORGANIZATION_UNITS HOU
 WHERE   1 = 1  
         AND HOU.ORGANIZATION_ID =
               APPS.GET_BU_ORGID (
                  SYSDATE ,
                  NVL (PA.ASS_ATTRIBUTE20, PA.ORGANIZATION_ID)
               )) BU_NAME
    FROM per_assessments pass,
         per_appraisals papp,
         HR.PER_ALL_ASSIGNMENTS_F pa,
         HR.PER_ALL_PEOPLE_F ppf,
         HR.PER_APPRAISAL_TEMPLATES patemp,
         per_perf_mgmt_plans ppmp,
         apps.hr_organization_units hou,
         hr_organization_information mang2
   WHERE     PASS.APPRAISAL_ID = PAPP.APPRAISAL_ID
   AND pa.ASS_ATTRIBUTE20 = hou.organization_id
   AND mang2.organization_id = hou.organization_id
   AND (sysdate BETWEEN TO_DATE (mang2.ORG_INFORMATION3,
                                      'rrrr/mm/dd hh24:mi:ss')
                         AND  NVL (
                                 TO_DATE (mang2.ORG_INFORMATION4,
                                          'rrrr/mm/dd hh24:mi:ss'),
                                 SYSDATE
                              )
--        or sysdate BETWEEN TO_DATE (mang2.ORG_INFORMATION3,
--                                      'rrrr/mm/dd hh24:mi:ss')
--                         AND  NVL (
--                                 TO_DATE (mang2.ORG_INFORMATION4,
--                                          'rrrr/mm/dd hh24:mi:ss'),
--                                 SYSDATE
--                              )
                              )
   AND mang2.org_information_context = 'Organization Name Alias'
         and ppmp.PLAN_ID = papp.PLAN_ID
         AND PPF.PERSON_ID = PA.PERSON_ID
         AND (ppmp.START_DATE BETWEEN PA.EFFECTIVE_START_DATE AND PA.EFFECTIVE_END_DATE
            --or ppmp.END_DATE BETWEEN PA.EFFECTIVE_START_DATE AND PA.EFFECTIVE_END_DATE
            )
         AND (ppmp.START_DATE BETWEEN ppf.EFFECTIVE_START_DATE AND ppf.EFFECTIVE_END_DATE
            --or ppmp.END_DATE BETWEEN ppf.EFFECTIVE_START_DATE AND ppf.EFFECTIVE_END_DATE
            )
         AND PASS.PERSON_ID = PPF.PERSON_ID
and papp.plan_id is not null
AND ((SELECT   
         HOU.ORGANIZATION_ID ORG_ID
  FROM  
         HR_ORGANIZATION_UNITS HOU
 WHERE   1 = 1  
         AND HOU.ORGANIZATION_ID =
               APPS.GET_BU_ORGID (
                  SYSDATE ,
                  NVL (PA.ASS_ATTRIBUTE20, PA.ORGANIZATION_ID)
               )) IN (:BUs)or LEAST ( :BUs) IS NULL)
AND (hou.ORGANIZATION_ID IN (:TEAM)or LEAST ( :TEAM) IS NULL)
         AND PATEMP.APPRAISAL_TEMPLATE_ID = PAPP.APPRAISAL_TEMPLATE_ID
--AND (PATEMP.APPRAISAL_TEMPLATE_ID=:TEMPLATE or LEAST ( :TEMPLATE) IS NULL)
AND (ppmp.PLAN_ID=:TEMPLATE or LEAST ( :TEMPLATE) IS NULL)
         AND (   (    :STATUS = 'COMPLETED'
                  AND papp.appraisal_system_status = 'COMPLETED')
              OR (    :STATUS = 'PENDINGAPPR'
                  AND papp.appraisal_system_status = 'PENDINGAPPR')
              OR (    :STATUS = 'PLANNED'
                  AND papp.appraisal_system_status IN ('ONGOING',
                                                       'TRANSFER',
                                                       'PLANNED',
                                                       'SAVED')) or LEAST ( :STATUS) IS NULL)
                                                       )
GROUP BY plan_id,
         ASSESSMENT_NAME,
         appraisal_system_status,
         TEAM_NAME,
         BU_NAME
ORDER BY 
BU_NAME,
TEAM_NAME,
ASSESSMENT_NAME 
ASC