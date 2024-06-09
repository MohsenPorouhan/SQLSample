SELECT   distinct per_grade.employee_number employee_number,--Per_Time_PRJ_TASK.ASSIGNMENT_NUMBER employee_number,/*13980516*/
         per_grade.full_name,
         per_grade.EFFECTIVE_START_DATE,
         per_grade.EFFECTIVE_END_DATE,
         org.D_child_NAME,
         org.organization_id_child,
         ppa.segment1,
         ppa.segment1 segment1_excel,
         ppa.PROJECT_ID,
         Per_Time_PRJ_TASK.time_period,
         to_char(Per_Time_PRJ_TASK.time_period,'rrrrmmdd','nls_calendar=persian') datete,
         ppa.CARRYING_OUT_ORGANIZATION_ID,
         ppa.long_name project_name,
         ppa.long_name project_name_excel,
         pt.task_id,
         pt.top_task_id,
         (SELECT MIN (task_number)
            FROM pa.pa_tasks
           WHERE task_id = pt.top_task_id)
            activity,
          (SELECT MIN (task_number)
            FROM pa.pa_tasks
           WHERE task_id = pt.top_task_id)
            activity_excel,
         (SELECT long_task_name
            FROM pa.pa_tasks
           WHERE     task_id = pt.top_task_id
                 AND task_number = (SELECT MIN (task_number)
                                      FROM pa.pa_tasks
                                     WHERE task_id = pt.top_task_id))
            activity_name,
         (SELECT long_task_name
            FROM pa.pa_tasks
           WHERE     task_id = pt.top_task_id
                 AND task_number = (SELECT MIN (task_number)
                                      FROM pa.pa_tasks
                                     WHERE task_id = pt.top_task_id))
            activity_name_excel,
         pt.task_number,
         pt.task_number task_number_excel,
         pt.wbs_level,
         pt.long_task_name,
         pt.long_task_name long_task_name_excel,
         NVL ('E' || per_grade.grade, 'E5') ASS_ATTRIBUTE17,
         (select ship_to_location from HR_LOCATIONS_V hlv where hlv.location_id = per_grade.location_id) ship_to_location,
         (case when 0 in (0,1,2,3,4) then ROUND (SUM (Per_Time_PRJ_TASK.NormalTime), 2) else 0 end) Normal_Time,
         (case when 1 in (0,1,2,3,4) then ROUND (SUM (Per_Time_PRJ_TASK.overtime), 2) else 0 end)  overtime,
         (case when 2 in (0,1,2,3,4) then ROUND (SUM (Per_Time_PRJ_TASK.InMissionTime), 2) else 0 end)         
         + (CASE
               WHEN :mission_work_type_code IN (31,
                                                32,
                                                33,
                                                34,
                                                35,
                                                36,
                                                37,
                                                38,
                                                39,
                                                310,
                                                311,
                                                312)
               THEN
                  ROUND (SUM (Per_Time_PRJ_TASK.OutMissionTime), 2)
               ELSE
                  0
            END)
         + (case when 4 in (0,1,2,3,4) then ROUND (SUM (Per_Time_PRJ_TASK.ForeignMissionTime), 2) else 0 end)         
            mission,
         --0 sum_time_sub_activity,
         (case when 0 in (0,1,2,3,4) then ROUND (SUM (Per_Time_PRJ_TASK.NormalTime * FER.ADDI_RATE)) else 0 end)
            NORMAL_TIME_EXPENSE,
         (case when 1 in (0,1,2,3,4) then ROUND (SUM (Per_Time_PRJ_TASK.overtime * FER.OVER_TIME_RATE)) else 0 end)
            overtime_EXPENSE,
         (case when 2 in (0,1,2,3,4) then ROUND (SUM (Per_Time_PRJ_TASK.InMissionTime * FER.DAROON_OSTAN)) else 0 end)           
         + (CASE
               WHEN :mission_work_type_code = 31
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_1))
               WHEN :mission_work_type_code = 32
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_2))
               WHEN :mission_work_type_code = 33
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_3))
               WHEN :mission_work_type_code = 34
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_4))
               WHEN :mission_work_type_code = 35
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_5))
               WHEN :mission_work_type_code = 36
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_6))
               WHEN :mission_work_type_code = 37
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_7))
               WHEN :mission_work_type_code = 38
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_8))
               WHEN :mission_work_type_code = 39
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_9))
               WHEN :mission_work_type_code = 310
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_10))
               WHEN :mission_work_type_code = 311
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_11))
               WHEN :mission_work_type_code = 312
               THEN
                  ROUND (
                     SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_12))
               ELSE
                  0
            END)
         + (case when 4 in (0,1,2,3,4) then ROUND (SUM (Per_Time_PRJ_TASK.ForeignMissionTime * FER.MISSION_FO)) else 0 end)         
            mission_expense,
         --0  sum_expense_sub_activity,
         per_grade.EMPLOYMENT_CATEGORY,
         per_grade.EMPLOYMENT_CATEGORY2,
         :from_date from_date,
         :end_date end_date
    FROM (SELECT distinct papf.person_id,
                 (select distinct papf1.full_name from apps.per_all_people_f papf1 where papf1.person_id = papf.person_id and rownum = 1) full_name,
                 papf.employee_number,
                 PAAF.EFFECTIVE_START_DATE,
                 PAAF.EFFECTIVE_END_DATE,
                 pgt.name grade,
                 LOCATION_ID,                 
                 DECODE (paaf.EMPLOYMENT_CATEGORY,
                         'FU', 'ايريسا',
                         'P3', 'ايريسا',
                         'P2', 'ايريسا',
                         'P1', 'ايريسا',
                         'P4', 'ايريسا',
                         'ّFL', 'ايريسا',
                         'P5', 'پيمانکار')
                    EMPLOYMENT_CATEGORY,
                 DECODE (paaf.EMPLOYMENT_CATEGORY,
                         'FU', 1,
                         'P3', 1,
                         'P2', 1,
                         'P1', 1,
                         'P4', 1,
                         'ّFL', 1,
                         'P5', 2)
                    EMPLOYMENT_CATEGORY2
            FROM apps.per_all_people_f papf,
                 apps.per_all_assignments_f paaf,
                 hr.PER_GRADES_TL pgt
           WHERE     papf.person_id = paaf.person_id
                 AND (TO_DATE ( :from_date, 'rrrrmmdd', 'nls_calendar=persian') BETWEEN PAPF.EFFECTIVE_START_DATE
                                                                                   AND PAPF.EFFECTIVE_END_DATE
                              or TO_DATE ( :end_date, 'rrrrmmdd', 'nls_calendar=persian') BETWEEN PAPF.EFFECTIVE_START_DATE
                                                                                   AND PAPF.EFFECTIVE_END_DATE
                                                                                   )
--------------------------------                 AND (TO_DATE ( :from_date, 'rrrrmmdd', 'nls_calendar=persian') BETWEEN PAAF.EFFECTIVE_START_DATE
--------------------------------                                                                                   AND PAAF.EFFECTIVE_END_DATE
--------------------------------                              or TO_DATE ( :end_date, 'rrrrmmdd', 'nls_calendar=persian') BETWEEN PAAF.EFFECTIVE_START_DATE
--------------------------------                                                                                   AND PAAF.EFFECTIVE_END_DATE
--------------------------------                                                                                   )
                 AND pgt.grade_id = NVL (paaf.grade_id, 65)) per_grade,
         (  SELECT icpv.project_id,
                   icpv.task_id,
                   icpv.TIME_PERIOD,
                   icpv.person_id,
                   icpv.ASSIGNMENT_NUMBER,
                   SUM (ICPV.NORMAL_TIME) NormalTime,
                   SUM (ICPV.EZFEKAR + BEYN_OVER + IR_OVER + KHAREJ_OVER)
                      OverTime,
                   SUM (ICPV.BEYN_NORMAL) InMissionTime,
                   SUM (ICPV.IR_NORMAL) OutMissionTime,
                   SUM (ICPV.KHAREJ_NORMAL) ForeignMissionTime
              FROM apps.irisa_charge_prj_v icpv
             WHERE     icpv.TIME_PERIOD BETWEEN TO_DATE ( :from_date,
                                                         'rrrrmmdd',
                                                         'nls_calendar=persian')
                                            AND TO_DATE ( :end_date,
                                                         'rrrrmmdd',
                                                         'nls_calendar=persian')
                   AND (   icpv.project_id IN ( :project_id)
                        OR LEAST ( :project_id) IS NULL)
          GROUP BY icpv.project_id,
                   icpv.task_id,
                   icpv.TIME_PERIOD,
                   icpv.ASSIGNMENT_NUMBER,
                   icpv.person_id
          ORDER BY 1) Per_Time_PRJ_TASK,
         xxel.fin_e_result fer,
         apps.pa_projects_all ppa,
         (SELECT DISTINCT pose1.D_child_NAME, pose1.organization_id_child
            FROM PER_ORG_STRUCTURE_ELEMENTS_V pose1
           WHERE     pose1.business_group_id = 81
                 AND pose1.org_structure_version_id =
                        (SELECT MAX (ORG_STRUCTURE_VERSION_ID)
                           FROM PER_ORG_STRUCTURE_VERSIONS_V
                          WHERE     ORGANIZATION_STRUCTURE_ID = 1061
                                AND (   DATE_FROM BETWEEN TO_DATE (
                                                             :from_date,
                                                             'rrrrmmdd',
                                                             'nls_calendar=persian')
                                                      AND TO_DATE (
                                                             :end_date,
                                                             'rrrrmmdd',
                                                             'nls_calendar=persian')
                                     OR NVL (
                                           DATE_TO,
                                           TO_DATE ( :end_date,
                                                    'rrrrmmdd',
                                                    'nls_calendar=persian')) BETWEEN TO_DATE (
                                                                                        :from_date,
                                                                                        'rrrrmmdd',
                                                                                        'nls_calendar=persian')
                                                                                 AND TO_DATE (
                                                                                        :end_date,
                                                                                        'rrrrmmdd',
                                                                                        'nls_calendar=persian')))
                 AND pose1.organization_id_parent = 81
                 union all --added by Mahdi Ajoudanian 13991213 because of project 1070 didn't shown
                 select 'شرکت ايريسا',81
                 from dual 
                 ) org,
         apps.pa_tasks pt
   WHERE per_grade.person_id = Per_Time_PRJ_TASK.person_id
         AND Per_Time_PRJ_TASK.TIME_PERIOD BETWEEN per_grade.EFFECTIVE_START_DATE
                                               AND per_grade.EFFECTIVE_END_DATE  
----------------------------         AND Per_Time_PRJ_TASK.TIME_PERIOD BETWEEN TO_DATE (
----------------------------                                                            :from_date,
----------------------------                                                            'rrrrmmdd',
----------------------------                                                            'nls_calendar=persian')
----------------------------                                                     AND TO_DATE (
----------------------------                                                            :end_date,
----------------------------                                                            'rrrrmmdd',
----------------------------                                                            'nls_calendar=persian')                                
         AND fer.grade = per_grade.grade
         AND to_number(to_char(FER.START_DATE,'rrrr','nls_calendar=persian'))  BETWEEN to_number(to_char(per_grade.EFFECTIVE_START_DATE,'rrrr','nls_calendar=persian'))
                                               AND to_number(to_char(per_grade.EFFECTIVE_END_DATE,'rrrr','nls_calendar=persian'))
         AND fer.LOC_CODE = (select distinct attribute1
                             from HR.HR_LOCATIONS_ALL                 
                                where location_id = per_grade.LOCATION_ID) --:location_code
         and    (fer.LOC_CODE in (:location_code) or   :location_code is null)                         
         AND TO_CHAR (fer.START_DATE, 'rrrr', 'nls_calendar=persian') BETWEEN SUBSTR (
                                                                                 :from_date,
                                                                                 1,
                                                                                 4)
                                                                          AND SUBSTR (
                                                                                 :end_date,
                                                                                 1,
                                                                                 4)
         AND TO_CHAR (Per_Time_PRJ_TASK.time_period, 'rrrr', 'nls_calendar=persian') = TO_CHAR (fer.START_DATE, 'rrrr', 'nls_calendar=persian')  
         AND ppa.project_id = Per_Time_PRJ_TASK.project_id
         AND pt.project_id = ppa.project_id
         AND pt.task_id = Per_Time_PRJ_TASK.task_id
         AND org.organization_id_child = ppa.CARRYING_OUT_ORGANIZATION_ID
         AND (   DECODE (per_grade.EMPLOYMENT_CATEGORY,
                         'FU', 1,
                         'P3', 1,
                         'P2', 1,
                         'P1', 1,
                         'P4', 1,
                         'ّFL', 1,
                         'P5', 2) IN
                    ( :EMPLOYMENT_CATEGORY)
              OR LEAST ( :EMPLOYMENT_CATEGORY) IS NULL)
         AND (ppa.PROJECT_ID IN ( :project_id) OR LEAST ( :project_id) IS NULL)
         AND (   ppa.CARRYING_OUT_ORGANIZATION_ID IN ( :org_id)
              OR LEAST ( :org_id) IS NULL)
         AND (   per_grade.person_id IN ( :person_id)
              OR LEAST ( :person_id) IS NULL)
         AND ppa.PROJECT_ID IN
                (SELECT ppp.project_id
                   FROM apps.PA_PROJECT_PLAYERS ppp,
                        pa.pa_projects_all ppa,
                        applsys.fnd_user fu
                  WHERE     ppa.project_id = ppp.project_id
                        AND TRUNC (SYSDATE) BETWEEN NVL (START_DATE_ACTIVE,
                                                         TRUNC (SYSDATE))
                                                AND NVL (END_DATE_ACTIVE,
                                                         TRUNC (SYSDATE))
                        AND FU.EMPLOYEE_ID = ppp.person_id
                        AND ppa.template_flag = 'N'
                        AND ppp.person_id =
                               (SELECT person_id
                                  FROM apps.per_all_people_f papf,
                                       apps.fnd_user fu
                                 WHERE     papf.person_id = fu.EMPLOYEE_ID
                                       AND fu.USER_NAME =
                                              (SELECT CASE
                                                         WHEN UPPER (
                                                                 :xdo_user_name) in
                                                                 ('POROHAN_DEV','OBIPHRDEV')
                                                         THEN
                                                            'M.AJOUDANIAN'
                                                         ELSE
                                                            UPPER (
                                                               :xdo_user_name)
                                                      END
                                                 FROM DUAL)
                                       AND SYSDATE BETWEEN papf.effective_start_date
                                                       AND papf.effective_end_date))
         AND (   per_grade.LOCATION_ID IN ( :work_place_code)
              OR LEAST ( :work_place_code) IS NULL) 
GROUP BY per_grade.employee_number, --Per_Time_PRJ_TASK.ASSIGNMENT_NUMBER, /*13980516*/
         full_name,         
         D_child_NAME,
         organization_id_child,
         ppa.PROJECT_ID,
         ppa.CARRYING_OUT_ORGANIZATION_ID,
         ppa.segment1,
         ppa.long_name,
         pt.task_id,
         top_task_id,
         task_number,
         wbs_level,
         long_task_name,
         EMPLOYMENT_CATEGORY,
         per_grade.grade,
         EMPLOYMENT_CATEGORY2,
         per_grade.location_id,
         Per_Time_PRJ_TASK.time_period,
         per_grade.EFFECTIVE_START_DATE,
         per_grade.EFFECTIVE_END_DATE
 HAVING (
 (case when 0 in (0,1,2,3,4) then (SUM (Per_Time_PRJ_TASK.NormalTime)) else 0 end) +
         (case when 1 in (0,1,2,3,4) then (SUM (Per_Time_PRJ_TASK.overtime)) else 0 end)  +
         (case when 2 in (0,1,2,3,4) then (SUM (Per_Time_PRJ_TASK.InMissionTime)) else 0 end)         
         + (CASE
               WHEN :mission_work_type_code IN (31,
                                                32,
                                                33,
                                                34,
                                                35,
                                                36,
                                                37,
                                                38,
                                                39,
                                                310,
                                                311,
                                                312)
               THEN
                  SUM (Per_Time_PRJ_TASK.OutMissionTime)
               ELSE
                  0
            END)
         + (case when 4 in (0,1,2,3,4) then SUM (Per_Time_PRJ_TASK.ForeignMissionTime) else 0 end) <> 0 )
ORDER BY (activity), wbs_level,per_grade.employee_number --Per_Time_PRJ_TASK.ASSIGNMENT_NUMBER /*13980516*/