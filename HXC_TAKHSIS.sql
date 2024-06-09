DROP VIEW APPS.IRISA_HXC_TAKHSIS;

/* Formatted on 5/7/2021 1:28:00 AM (QP5 v5.313) */
CREATE OR REPLACE FORCE VIEW APPS.IRISA_HXC_TAKHSIS
(
    FULL_NAME,
    EMPLOYEE_NUMBER,
    PERSON_ID,
    START_DATE,
    TKHSIS_ADII,
    TAKHSIS_OVER,
    TAKHSIS_BEYN,
    TAKHSIS_MISSON,
    TOTAL_ADI,
    TOTAL_OVER,
    TOTAL_BEYN,
    TOTAL_MISS,
    REM_ADI,
    REM_OVER,
    REM_BEYN,
    REM_MISSON,
    COUNT_WORKING
)
AS
      SELECT full_name,
             employee_number,
             person_id,
             start_date,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (SUM (TRUNC (adii, 2)), 2)
                 tkhsis_adii,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (SUM (TRUNC (over_time, 2)), 2)
                 takhsis_over,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (SUM (TRUNC (beyn, 2)), 2)
                 takhsis_beyn,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (SUM (TRUNC (miss, 2)), 2)
                 takhsis_misson,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (SUM (TRUNC (total_adi, 2)), 2)
                 total_adi,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (SUM (TRUNC (total_over, 2)), 2)
                 total_over,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (SUM (TRUNC (total_beyn, 2)), 2)
                 total_beyn,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (SUM (TRUNC (total_miss, 2)), 2)
                 total_miss,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (
                   NVL (SUM (TRUNC (total_adi, 2)), 0)
                 - NVL (SUM (TRUNC (adii, 2)), 0),
                 2)
                 rem_adi,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (
                   NVL (SUM (TRUNC (total_over, 2)), 0)
                 - NVL (SUM (TRUNC (over_time, 2)), 0),
                 2)
                 rem_over,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (
                   NVL (SUM (TRUNC (total_beyn, 2)), 0)
                 - NVL (SUM (TRUNC (beyn, 2)), 0),
                 2)
                 rem_beyn,
             --            irisa_payroll_pkg.time_tochar3
             apps.irisa_otl_pkg.round2 (
                   NVL (SUM (TRUNC (total_miss, 2)), 0)
                 - NVL (SUM (TRUNC (miss, 2)), 0),
                 2)
                 rem_misson,
             (SELECT COUNT (*)
                FROM apps.irisa_timecard_det2 itd
               WHERE     itd.person_id = all_row.person_id
                     AND itd.start_date = all_row.start_date
                     AND itd.approval_timecard IN ('WORKING', 'REJECTED'))
                 count_working
        FROM (  SELECT full_name                                 full_name,
                       employee_number,
                       person_id,
                       charge_type                               attribute3,
                       start_date,
                       case
                        when 'کار عادي' = charge_type then apps.irisa_otl_pkg.round_time (SUM (measure)) else 0
                       end adii,
                       case
                        when charge_type IN ('اضافه کار', 'فراخوان') then apps.irisa_otl_pkg.round_time (SUM (measure)) else 0
                       end                                         over_time,
                       case
                        when charge_type IN('ماموريت اداري','ماموريت خارج از کشور') then apps.irisa_otl_pkg.round_time (SUM (measure)) else 0
                       end                                         miss,
                       case
                        when 'ماموريت درون استان' = charge_type then apps.irisa_otl_pkg.round_time (SUM (measure)) else 0
                       end                                         beyn,
                       0                                         total_adi,
                       0                                         total_over,
                       0                                         total_beyn,
                       0                                         total_miss,
                       approval_timecard
                  FROM apps.irisa_timecard_det2
                 WHERE 1 = 1 AND  charge_type in('کار عادي','اضافه کار', 'فراخوان','ماموريت اداري','ماموريت خارج از کشور','ماموريت درون استان')
              -- AND APPROVAL_TIMECARD <> 'WORKING'
              GROUP BY full_name,
                       employee_number,
                       person_id,
                       charge_type,
                       start_date,
                       approval_timecard
              UNION ALL
                SELECT pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       'كار عادي'
                           typ,
                       TO_CHAR (ior.date_cal,
                                'rrrr/mm/dd',
                                'nls_calendar=persian')
                           da,
                       0,
                       0,
                       0,
                       0,
                       apps.irisa_otl_pkg.round_time ((SUM (ior.duration) * 24))
                           dur,
                       0,
                       0,
                       0,
                       NULL
                  FROM hr.irisa_otl_result ior
                       join hr.per_all_people_f pf on pf.person_id = ior.person_id
                       join hr_locations     hl1 on NVL (loc, 17) = hl1.attribute1
                 WHERE     
                       (ior.TYPE = 'P' OR absence_type IN (11062))
                       -- AND  IOR.date_cal=to_date(:p_start_date,'YYYY/MM/DD','nls_calendar=persian')
                       AND ior.date_cal BETWEEN pf.effective_start_date
                                            AND pf.effective_end_date
                       AND NVL (hl1.attribute8, 0) = 0
              GROUP BY pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       ior.date_cal
              UNION ALL
                SELECT full_name,
                       employee_number,
                       person_id,
                       'اضافه كار'
                           typ,
                       TO_CHAR (date_cal, 'rrrr/mm/dd', 'nls_calendar=persian')
                           da,
                       0,
                       0,
                       0,
                       0,
                       0,
                       apps.irisa_otl_pkg.round_time (SUM (dur))
                           dur,
                       0,
                       0,
                       NULL
                  FROM (SELECT (ior.duration) * 24 dur,
                               ior.person_id,
                               ior.date_cal,
                               pf.full_name,
                               pf.employee_number
                          FROM hr.irisa_otl_result ior join hr.per_all_people_f pf on pf.person_id = ior.person_id
                         WHERE     ior.TYPE IN ('O', 'H')
                               AND ior.date_cal BETWEEN pf.effective_start_date
                                                    AND pf.effective_end_date
                        UNION ALL
                        SELECT (ior.duration * 24) + 1.5 dur,
                               ior.person_id,
                               ior.date_cal,
                               pf.full_name,
                               pf.employee_number
                          FROM hr.irisa_otl_result ior join hr.per_all_people_f pf on pf.person_id = ior.person_id
                         WHERE     ior.TYPE IN ('F') 
                               AND ior.date_cal BETWEEN pf.effective_start_date
                                                    AND pf.effective_end_date
                                                                             )
              GROUP BY full_name,
                       employee_number,
                       person_id,
                       date_cal
              UNION ALL
                SELECT pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       'ماموريت درون استان'
                           typ,
                       TO_CHAR (ior.date_cal,
                                'rrrr/mm/dd',
                                'nls_calendar=persian')
                           da,
                       0,
                       0,
                       0,
                       0,
                       0,
                       0,
                       apps.irisa_otl_pkg.round_time (SUM (ior.duration) * 24)
                           dur,
                       0,
                       NULL
                  FROM hr.irisa_otl_result ior
                       join hr_locations     hl1 on NVL (loc, 17) = hl1.attribute1
                       join hr.per_all_people_f pf on pf.person_id = ior.person_id
                 WHERE     
                       (ior.TYPE = 'P' OR absence_type IN (11062))
                       -- AND  IOR.date_cal=to_date(:p_start_date,'YYYY/MM/DD','nls_calendar=persian')
                       AND ior.date_cal BETWEEN pf.effective_start_date
                                            AND pf.effective_end_date
                       AND NVL (hl1.attribute8, 0) <> 0
              GROUP BY pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       ior.date_cal
              UNION ALL
                SELECT pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       'ماموريت اداري'
                           typ,
                       TO_CHAR (ior.date_cal,
                                'rrrr/mm/dd',
                                'nls_calendar=persian')
                           da,
                       0,
                       0,
                       0,
                       0,
                       0,
                       0,
                       0,
                       apps.irisa_otl_pkg.round_time (SUM (ior.duration) * 24)
                           dur,
                       NULL
                  FROM hr.irisa_otl_result ior join hr.per_all_people_f pf on pf.person_id = ior.person_id
                 WHERE     1 = 1
                       --and IOR.date_cal=to_date(:p_start_date,'YYYY/MM/DD','nls_calendar=persian')
                       AND ior.absence_type IN (7065,
                                                7066,
                                                7067,
                                                115)
                       AND ior.TYPE IN ('A')
                       AND ior.date_cal BETWEEN pf.effective_start_date
                                            AND pf.effective_end_date
              GROUP BY pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       ior.date_cal
              UNION ALL
                SELECT pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       'كار عادي'
                           typ,
                       TO_CHAR (ior.date_cal,
                                'rrrr/mm/dd',
                                'nls_calendar=persian')
                           da,
                       0,
                       0,
                       0,
                       0,
                       apps.irisa_otl_pkg.round_time ((SUM (ior.duration) * 24))
                           dur,
                       0,
                       0,
                       0,
                       NULL
                  FROM hr.irisa_otl_result_pro ior
                       join hr_locations         hl1 on NVL (loc, 17) = hl1.attribute1
                       join hr.per_all_people_f  pf on pf.person_id = ior.person_id
                 WHERE     
                       (ior.TYPE = 'P' OR absence_type IN (11062))
                       -- AND  IOR.date_cal=to_date(:p_start_date,'YYYY/MM/DD','nls_calendar=persian')
                       AND ior.date_cal BETWEEN pf.effective_start_date
                                            AND pf.effective_end_date
                       AND NVL (hl1.attribute8, 0) = 0
              GROUP BY pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       ior.date_cal
              UNION ALL
                SELECT full_name,
                       employee_number,
                       person_id,
                       'اضافه كار'
                           typ,
                       TO_CHAR (date_cal, 'rrrr/mm/dd', 'nls_calendar=persian')
                           da,
                       0,
                       0,
                       0,
                       0,
                       0,
                       apps.irisa_otl_pkg.round_time (SUM (dur))
                           dur,
                       0,
                       0,
                       NULL
                  FROM (SELECT (ior.duration) * 24 dur,
                               ior.person_id,
                               ior.date_cal,
                               pf.full_name,
                               pf.employee_number
                          FROM hr.irisa_otl_result_pro ior
                               join hr.per_all_people_f  pf on pf.person_id = ior.person_id
                         WHERE     ior.TYPE IN ('O', 'H')
                               AND ior.date_cal BETWEEN pf.effective_start_date
                                                    AND pf.effective_end_date
                        UNION ALL
                        SELECT (ior.duration * 24) + 1.5 dur,
                               ior.person_id,
                               ior.date_cal,
                               pf.full_name,
                               pf.employee_number
                          FROM hr.irisa_otl_result_pro ior
                               join hr.per_all_people_f  pf on pf.person_id = ior.person_id
                         WHERE     ior.TYPE IN ('F')
                               AND ior.date_cal BETWEEN pf.effective_start_date
                                                    AND pf.effective_end_date
                                                                             )
              GROUP BY full_name,
                       employee_number,
                       person_id,
                       date_cal
              UNION ALL
                SELECT pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       'ماموريت درون استان'
                           typ,
                       TO_CHAR (ior.date_cal,
                                'rrrr/mm/dd',
                                'nls_calendar=persian')
                           da,
                       0,
                       0,
                       0,
                       0,
                       0,
                       0,
                       apps.irisa_otl_pkg.round_time (SUM (ior.duration) * 24)
                           dur,
                       0,
                       NULL
                  FROM hr.irisa_otl_result_pro ior
                       join hr_locations         hl1 on NVL (loc, 17) = hl1.attribute1
                       join hr.per_all_people_f  pf on pf.person_id = ior.person_id
                 WHERE     
                       (ior.TYPE = 'P' OR absence_type IN (11062))
                       -- AND  IOR.date_cal=to_date(:p_start_date,'YYYY/MM/DD','nls_calendar=persian')
                       AND ior.date_cal BETWEEN pf.effective_start_date
                                            AND pf.effective_end_date
                       AND NVL (hl1.attribute8, 0) <> 0
              GROUP BY pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       ior.date_cal
              UNION ALL
                SELECT pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       'ماموريت اداري'
                           typ,
                       TO_CHAR (ior.date_cal,
                                'rrrr/mm/dd',
                                'nls_calendar=persian')
                           da,
                       0,
                       0,
                       0,
                       0,
                       0,
                       0,
                       0,
                       apps.irisa_otl_pkg.round_time (SUM (ior.duration) * 24)
                           dur,
                       NULL
                  FROM hr.irisa_otl_result_pro ior join hr.per_all_people_f pf on pf.person_id = ior.person_id
                 WHERE     1 = 1
                       --and IOR.date_cal=to_date(:p_start_date,'YYYY/MM/DD','nls_calendar=persian')
                       AND ior.absence_type IN (7065,
                                                7066,
                                                7067,
                                                115)
                       AND ior.TYPE IN ('A')
                       AND ior.date_cal BETWEEN pf.effective_start_date
                                            AND pf.effective_end_date
              GROUP BY pf.full_name,
                       pf.employee_number,
                       pf.person_id,
                       ior.date_cal) all_row
       WHERE start_date >= '1397/01/01'
    GROUP BY full_name,
             employee_number,
             person_id,
             start_date;


CREATE OR REPLACE SYNONYM SE_HR.IRISA_HXC_TAKHSIS FOR APPS.IRISA_HXC_TAKHSIS;


GRANT SELECT ON APPS.IRISA_HXC_TAKHSIS TO HR_Q_ALL;
