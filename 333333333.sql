select 
    count(PASS.PERSON_ID)
    ,PAT.name
    ,papp.plan_id
from
    HR.PER_APPRAISAL_TEMPLATES pat join per_appraisals papp on PAT.APPRAISAL_TEMPLATE_ID = PAPP.APPRAISAL_TEMPLATE_ID
    join per_assessments pass on PAPP.APPRAISAL_ID = pass.APPRAISAL_ID
where
    papp.plan_id is not null
    AND (PAT.APPRAISAL_TEMPLATE_ID=:TEMPLATE or LEAST ( :TEMPLATE) IS NULL)
group by  
    PAt.name,
    papp.plan_id
