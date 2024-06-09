SELECT DISTINCT 
       ppa.segment1,
       ppa.PROJECT_ID,
       org.D_child_NAME,
       org.D_child_NAME D_child_NAME_excel,
       ppa.CARRYING_OUT_ORGANIZATION_ID,
       ppa.long_name project_name,
       (CASE
           WHEN 0 IN (0) THEN ROUND (SUM (Per_Time_PRJ_TASK.NormalTime), 2)
           ELSE 0
        END)
          Normal_Time,
       (CASE
           WHEN 1 IN (1) THEN ROUND (SUM (Per_Time_PRJ_TASK.overtime), 2)
           ELSE 0
        END)
          over_time,
         (CASE
             WHEN 2 IN (2)
             THEN
                ROUND (SUM (Per_Time_PRJ_TASK.InMissionTime), 2)
             ELSE
                0
          END)
       + (CASE
             WHEN 31 IN (31,
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
       + (CASE
             WHEN 4 IN (4)
             THEN
                ROUND (SUM (Per_Time_PRJ_TASK.ForeignMissionTime), 2)
             ELSE
                0
          END)
          mission,
         (CASE
             WHEN 0 IN (0) THEN ROUND (SUM (Per_Time_PRJ_TASK.NormalTime), 2)
             ELSE 0
          END)
       + (CASE
             WHEN 1 IN (1) THEN ROUND (SUM (Per_Time_PRJ_TASK.overtime), 2)
             ELSE 0
          END)
       + (CASE
             WHEN 2 IN (2)
             THEN
                ROUND (SUM (Per_Time_PRJ_TASK.InMissionTime), 2)
             ELSE
                0
          END)
       + (CASE
             WHEN 31 IN (31,
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
       + (CASE
             WHEN 4 IN (4)
             THEN
                ROUND (SUM (Per_Time_PRJ_TASK.ForeignMissionTime), 2)
             ELSE
                0
          END)
          total_time,
       (CASE
           WHEN 0 IN (0)
           THEN
              ROUND (SUM (Per_Time_PRJ_TASK.NormalTime * FER.ADDI_RATE))
           ELSE
              0
        END)
          NORMAL_TIME_EXPENSE,
       (CASE
           WHEN 1 IN (1)
           THEN
              ROUND (SUM (Per_Time_PRJ_TASK.overtime * FER.OVER_TIME_RATE))
           ELSE
              0
        END)
          over_time_expense,
         (CASE
             WHEN 2 IN (2)
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.InMissionTime * FER.DAROON_OSTAN))
             ELSE
                0
          END)
       + (CASE
             WHEN 31 = 31
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_1))
             WHEN 32 = 32
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_2))
             WHEN 33 = 33
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_3))
             WHEN 34 = 34
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_4))
             WHEN 35 = 35
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_5))
             WHEN 36 = 36
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_6))
             WHEN 37 = 37
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_7))
             WHEN 38 = 38
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_8))
             WHEN 39 = 39
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_9))
             WHEN 310 = 310
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_10))
             WHEN 311 = 311
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_11))
             WHEN 312 = 312
             THEN
                ROUND (
                   SUM (Per_Time_PRJ_TASK.OutMissionTime * FER.MISSION_12))
             ELSE
                0
          END)
       + (CASE
             WHEN 4 IN (4)
             THEN
                ROUND (
                   SUM (
                      Per_Time_PRJ_TASK.ForeignMissionTime * FER.MISSION_FO))
             ELSE
                0
          END)
          mission_expense,
       project_type,
       project_type project_type_excel,
       TO_CHAR (TO_DATE ( :from_date, 'rrrrmmdd', 'nls_calendar=persian'),
                'rrrr/mm/dd',
                'nls_calendar=persian')
          from_date,
       TO_CHAR (TO_DATE ( :end_date, 'rrrrmmdd', 'nls_calendar=persian'),
                'rrrr/mm/dd',
                'nls_calendar=persian')
          end_date,
       DECODE (project_type,
               'عملياتي', '1',
               'غيرعملياتي', '2',
               'سرمايه اي', '3')
          project_type2,
       :xdo_USER_NAME USER_NAME
  FROM (SELECT DISTINCT
               papf.person_id,
               (SELECT DISTINCT papf1.full_name
                  FROM apps.per_all_people_f papf1
                 WHERE papf1.person_id = papf.person_id AND ROWNUM = 1)
                  full_name,
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
               AND (   TO_DATE ( :from_date,
                                'rrrrmmdd',
                                'nls_calendar=persian') BETWEEN PAPF.EFFECTIVE_START_DATE
                                                            AND PAPF.EFFECTIVE_END_DATE
                    OR TO_DATE ( :end_date,
                                'rrrrmmdd',
                                'nls_calendar=persian') BETWEEN PAPF.EFFECTIVE_START_DATE
                                                            AND PAPF.EFFECTIVE_END_DATE)
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
                 AND (   icpv.project_id IN ( :project_code)
                      OR LEAST ( :project_code) IS NULL)
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
               AND pose1.organization_id_parent = 81) org,
       apps.pa_tasks pt
 WHERE     per_grade.person_id = Per_Time_PRJ_TASK.person_id
       AND Per_Time_PRJ_TASK.TIME_PERIOD BETWEEN per_grade.EFFECTIVE_START_DATE
                                             AND per_grade.EFFECTIVE_END_DATE
       AND fer.grade = per_grade.grade
       AND TO_NUMBER (
              TO_CHAR (FER.START_DATE, 'rrrr', 'nls_calendar=persian')) BETWEEN TO_NUMBER (
                                                                                   TO_CHAR (
                                                                                      per_grade.EFFECTIVE_START_DATE,
                                                                                      'rrrr',
                                                                                      'nls_calendar=persian'))
                                                                            AND TO_NUMBER (
                                                                                   TO_CHAR (
                                                                                      per_grade.EFFECTIVE_END_DATE,
                                                                                      'rrrr',
                                                                                      'nls_calendar=persian'))
       AND fer.LOC_CODE = (SELECT DISTINCT attribute1
                             FROM HR.HR_LOCATIONS_ALL
                            WHERE location_id = per_grade.LOCATION_ID) 
       AND TO_CHAR (fer.START_DATE, 'rrrr', 'nls_calendar=persian') BETWEEN SUBSTR (
                                                                               :from_date,
                                                                               1,
                                                                               4)
                                                                        AND SUBSTR (
                                                                               :end_date,
                                                                               1,
                                                                               4)
       AND TO_CHAR (Per_Time_PRJ_TASK.time_period,
                    'rrrr',
                    'nls_calendar=persian') =
              TO_CHAR (fer.START_DATE, 'rrrr', 'nls_calendar=persian')
       AND ppa.project_id = Per_Time_PRJ_TASK.project_id
       AND pt.project_id = ppa.project_id
       AND pt.task_id = Per_Time_PRJ_TASK.task_id
       AND org.organization_id_child = ppa.CARRYING_OUT_ORGANIZATION_ID
       AND (   DECODE (per_grade.EMPLOYMENT_CATEGORY,
                       'FU', 'ايريسا',
                       'P3', 'ايريسا',
                       'P2', 'ايريسا',
                       'P1', 'ايريسا',
                       'P4', 'ايريسا',
                       'ّFL', 'ايريسا',
                       'P5', 'پيمانکار') IN
                  ( :EMPLOYMENT_CATEGORY)
            OR LEAST ( :EMPLOYMENT_CATEGORY) IS NULL)
       AND (   ppa.PROJECT_ID IN ( :project_code)
            OR LEAST ( :project_code) IS NULL)
       AND (   ppa.CARRYING_OUT_ORGANIZATION_ID IN ( :organization_id)
            OR LEAST ( :organization_id) IS NULL)
       AND (   project_type IN ( :project_type)
            OR LEAST ( :project_type) IS NULL)
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
GROUP BY D_child_NAME,
       ppa.PROJECT_ID,
       ppa.CARRYING_OUT_ORGANIZATION_ID,
       ppa.project_type,
       ppa.segment1,
       ppa.long_name                              
HAVING (  (CASE
              WHEN 0 IN (0) THEN (SUM (Per_Time_PRJ_TASK.NormalTime))
              ELSE 0
           END)
        + (CASE
              WHEN 1 IN (1) THEN (SUM (Per_Time_PRJ_TASK.overtime))
              ELSE 0
           END)
        + (CASE
              WHEN 2 IN (2) THEN (SUM (Per_Time_PRJ_TASK.InMissionTime))
              ELSE 0
           END)
        + (CASE
              WHEN 31 IN (31,
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
        + (CASE
              WHEN 4 IN (4) THEN SUM (Per_Time_PRJ_TASK.ForeignMissionTime)
              ELSE 0
           END) <> 0)
order by ppa.segment1