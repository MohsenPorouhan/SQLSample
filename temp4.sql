/* Formatted on 8/23/2020 3:38:36 ?.? (QP5 v5.287) */
  SELECT EMPLOYEE_NUMBER,
         FULL_NAME,
         PROJECT_NUM,
         (day_ir_mis) day_ir_mis,
         (day_kharej_mis) day_kharej_mis,
         apps.irisa_payroll_pkg.time_tochar3 ( (hour_kharej_mis))
            hour_kharej_mis2,
         apps.irisa_payroll_pkg.time_tochar3 ( (hour_ir_mis)) hour_ir_mis2,
         apps.irisa_payroll_pkg.time_tochar3 ( (hour_addi)) hour_addi2,
         apps.irisa_payroll_pkg.time_tochar3 ( (hour_over)) hour_over2,
         apps.irisa_payroll_pkg.time_tochar3 ( (hour_daroon)) hour_daroon2,
         --------
         (hour_kharej_mis) hour_kharej_mis,
         (hour_ir_mis) hour_ir_mis,
         (hour_addi) hour_addi,
         (hour_over) hour_over,
         (hour_daroon) hour_daroon,
         ROUND (
            NVL (
               apps.irisa_otl_pkg.total_leave (SUBSTR ( :p_start, 1, 6),
                                               SUBSTR ( :p_end, 1, 6),
                                               person_id),
               2),
            0)
            rem_leave,
         START_DATE,
         TASK_NAME,
         TASK_NUMBER,
         V.PERSON_ID,
         APPROVAL_TIMECARD
    FROM (  SELECT APPROVAL_TIMECARD, EMPLOYEE_NUMBER,
                   PERSON_ID,
                   FULL_NAME,
                   CHARGE_TYPE,
                   PROJECT_NUM,
                   START_DATE,
                   CASE
                      WHEN CHARGE_TYPE = '??? ????' THEN SUM (MEASURE)
                      ELSE 0
                   END
                      hour_addi,
                   CASE
                      WHEN CHARGE_TYPE = '????? ???' THEN SUM (MEASURE)
                      ELSE 0
                   END
                      hour_over,
                   CASE
                      WHEN CHARGE_TYPE = '??????? ???? ?????'
                      THEN
                         SUM (MEASURE)
                      ELSE
                         0
                   END
                      hour_daroon,
                   CASE
                      WHEN CHARGE_TYPE = '??????? ???? ?? ????'
                      THEN
                         CEIL (SUM (MEASURE) / 24)
                      ELSE
                         0
                   END
                      day_kharej_mis,
                   CASE
                      WHEN CHARGE_TYPE = '??????? ?????'
                      THEN
                         CEIL (SUM (MEASURE) / 24)
                      ELSE
                         0
                   END
                      day_ir_mis,
                   CASE
                      WHEN CHARGE_TYPE = '??????? ???? ?? ????'
                      THEN
                         SUM (MEASURE)
                      ELSE
                         0
                   END
                      hour_kharej_mis,
                   CASE
                      WHEN CHARGE_TYPE = '??????? ?????'
                      THEN
                         SUM (MEASURE)
                      ELSE
                         0
                   END
                      hour_ir_mis,
                   TASK_NAME,
                   TASK_NUMBER
              FROM APPS.IRISA_TIMECARD_DET2
             WHERE     START_DATE2 BETWEEN NVL ( :p_start, '13980101')
                                       AND NVL (
                                              :p_end,
                                              TO_CHAR (SYSDATE,
                                                       'rrrrmmdd',
                                                       'nls_calendar=persian'))
                   -- and CHARGE_TYPE in ('??? ????','????? ???','??????? ???? ?????')
                   AND (EMPLOYEE_NUMBER IN ( :p_emp) OR LEAST ( :p_emp) IS NULL)
                   AND PROJECT_id IN ( :P_PROJ)
                   AND APPROVAL_TIMECARD IN ( :P_VAZIYAT)
          GROUP BY EMPLOYEE_NUMBER,
                   FULL_NAME,
                   CHARGE_TYPE,
                   PROJECT_NUM,
                   START_DATE,
                   PERSON_ID,
                   TASK_NAME,
                   TASK_NUMBER,
                   APPROVAL_TIMECARD) V
   WHERE V.PERSON_ID IN
            (SELECT PERSON_ID
               FROM HR.PER_ALL_ASSIGNMENTS_F PAA
              WHERE        PAA.PERSON_ID = V.PERSON_ID
                       AND SYSDATE BETWEEN PAA.EFFECTIVE_START_DATE
                                       AND PAA.EFFECTIVE_END_DATE
                       AND PAa.ASS_ATTRIBUTE20 IN
                              (    SELECT pose.organization_id_child
                                     FROM (SELECT DISTINCT
                                                  pose1.organization_id_child,
                                                  pose1.organization_id_parent,
                                                  pose1.d_child_name
                                             FROM PER_ORG_STRUCTURE_ELEMENTS_V
                                                  pose1
                                            WHERE     pose1.business_group_id = 81
                                                  AND pose1.org_structure_version_id =
                                                         (SELECT ORG_STRUCTURE_VERSION_ID
                                                            FROM PER_ORG_STRUCTURE_VERSIONS_V
                                                           WHERE     ORGANIZATION_STRUCTURE_ID =
                                                                        1061
                                                                 AND TO_DATE (
                                                                        :p_start,
                                                                        'rrrrmmdd',
                                                                        'nls_calendar=persian') BETWEEN DATE_FROM
                                                                                                    AND NVL (
                                                                                                           DATE_TO,
                                                                                                             SYSDATE
                                                                                                           + 1000)))
                                          pose
                               CONNECT BY PRIOR pose.organization_id_child =
                                             pose.organization_id_parent
                               START WITH (pose.organization_id_Parent IN (:P_GROUPS) 
                                           or (:P_GROUPS is null and pose.ORGANIZATION_ID_PARENT in(SELECT organization_id
                                                    FROM hr_organization_units
                                                   WHERE     organization_id IN
                                                                (    SELECT pose.organization_id_child
                                                                       FROM (SELECT DISTINCT
                                                                                    pose1.organization_id_child,
                                                                                    pose1.organization_id_parent,
                                                                                    pose1.d_child_name
                                                                               FROM PER_ORG_STRUCTURE_ELEMENTS_V
                                                                                    pose1
                                                                              WHERE     pose1.business_group_id =
                                                                                           81
                                                                                    AND pose1.org_structure_version_id =
                                                                                           (SELECT ORG_STRUCTURE_VERSION_ID
                                                                                              FROM PER_ORG_STRUCTURE_VERSIONS_V
                                                                                             WHERE     ORGANIZATION_STRUCTURE_ID =
                                                                                                          1061
                                                                                                   AND SYSDATE BETWEEN DATE_FROM
                                                                                                                   AND NVL (
                                                                                                                          DATE_TO,
                                                                                                                            SYSDATE
                                                                                                                          + 1000)))
                                                                            pose
                                                                 CONNECT BY PRIOR pose.organization_id_child =
                                                                               pose.organization_id_parent
                                                                 START WITH pose.organization_id_Parent =
                                                                               (SELECT organization_id
                                                                                  FROM fnd_user
                                                                                       fu,
                                                                                       hr.per_all_assignments_f
                                                                                       pf
                                                                                 WHERE     fu.user_name =
                                                                                              (CASE
                                                                                                  WHEN UPPER (
                                                                                                          :xdo_user_name) =
                                                                                                          'POROHAN_DEV'
                                                                                                  THEN
                                                                                                     'H.JALALIPOOR'
                                                                                                  ELSE
                                                                                                     UPPER (
                                                                                                        :xdo_user_name)
                                                                                               END)
                                                                                       AND SYSDATE BETWEEN effective_start_date
                                                                                                       AND effective_end_date
                                                                                       AND employee_id =
                                                                                              pf.person_id)
                                                                 UNION
                                                                 SELECT organization_id
                                                                   FROM fnd_user
                                                                        fu,
                                                                        hr.per_all_assignments_f
                                                                        pf
                                                                  WHERE     fu.user_name =
                                                                               (CASE
                                                                                   WHEN UPPER (
                                                                                           :xdo_user_name) =
                                                                                           'POROHAN_DEV'
                                                                                   THEN
                                                                                      'H.JALALIPOOR'
                                                                                   ELSE
                                                                                      UPPER (
                                                                                         :xdo_user_name)
                                                                                END)
                                                                        AND SYSDATE BETWEEN effective_start_date
                                                                                        AND effective_end_date
                                                                        AND employee_id =
                                                                               pf.person_id)
                                                         ))
                                                 )
                                                 union 
                                                 (SELECT  organization_id
                                                      FROM hr_organization_units WHERE 1=1
                                                    and (organization_id in(:P_GROUPS) or(:P_GROUPS is null and organization_id= (SELECT organization_id
                                                                 FROM apps.fnd_user fu, hr.per_all_assignments_f pf
                                                                WHERE     fu.user_name =
                                                                             (CASE
                                                                                 WHEN UPPER ( :xdo_user_name) = 'POROHAN_DEV'
                                                                                 THEN
                                                                                    'H.JALALIPOOR'
                                                                                 ELSE
                                                                                    UPPER ( :xdo_user_name)
                                                                              END)
                                                                      AND SYSDATE BETWEEN effective_start_date
                                                                                      AND effective_end_date
                                                                      AND employee_id = pf.person_id)))
                  )
                                                 )
                                     )
--GROUP BY EMPLOYEE_NUMBER,person_id, FULL_NAME, PROJECT_NUM,START_DATE
ORDER BY EMPLOYEE_NUMBER, START_DATE