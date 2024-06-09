select papf.employee_number,papf.full_name
,apps.irisa_payroll_pkg.nonrec_entry(paaf.assignment_id,6491,1046,to_date(:p_date,'rrrrmmdd','nls_calendar=persian'))rate_value
,round((apps.irisa_payroll_pkg.nonrec_entry(paaf.assignment_id,6491,1046,to_date(:p_date,'rrrrmmdd','nls_calendar=persian'))/100)*
(SELECT global_value 
FROM FF_GLOBALS_F_VL
WHERE GLOBAL_ID = 478
  AND to_date(:p_date,'rrrrmmdd','nls_calendar=persian')  BETWEEN EFFECTIVE_START_DATE
                                 AND EFFECTIVE_END_DATE
                                 )
                                 )responsibility_rate
from 
apps.per_all_people_f papf,
apps.per_all_assignments_f paaf
--PER_PERSON_TYPE_USAGES_F pptuf,
where 
1=1
and papf.person_id=paaf.person_id
--and papf.person_id=pptuf.person_id
and papf.person_type_id=1120
and to_date(:p_date,'rrrrmmdd','nls_calendar=persian') between papf.effective_start_date and papf.effective_end_date
and to_date(:p_date,'rrrrmmdd','nls_calendar=persian') between paaf.effective_start_date and paaf.effective_end_date
--and to_date(:p_date,'rrrrmmdd','nls_calendar=persian') between pptuf.effective_start_date and pptuf.effective_end_date
and apps.irisa_payroll_pkg.nonrec_entry(paaf.assignment_id,6491,1046,to_date(:p_date,'rrrrmmdd','nls_calendar=persian')) <>0