DROP VIEW APPS.IRISA_TIMECARD_DET2;

/* Formatted on 5/7/2021 6:04:33 AM (QP5 v5.313) */
CREATE OR REPLACE FORCE VIEW APPS.IRISA_TIMECARD_DET2
(
    FULL_NAME,
    EMPLOYEE_NUMBER,
    PROJECT_ID,
    TASK_ID,
    CHARGE_TYPE,
    PROJECT_NUM,
    TASK_NAME,
    TASK_NUMBER,
    START_DATE,
    MON_CHARGE,
    MEASURE,
    PERSON_ID,
    APPROVAL_DET,
    APPROVAL_DAY,
    APPROVAL_TIMECARD,
    START_DATE2,
    START_DATE3,
    ATT6,
    ATT5
)
AS
    SELECT ppx.full_name,
           ppx.employee_number,
           tap.attribute1
               project_id,
           tap.attribute2
               task_id,
           tap.attribute3
               charge_type,
           pp.segment1
               project_num,
           pt.task_name,
           pt.task_number,
           TO_CHAR (tbbde2.start_time, 'rrrr/mm/dd', 'nls_calendar=persian')
               start_date,
           TO_CHAR (tbbde2.start_time, 'rrrrmm', 'nls_calendar=persian')
               mon_charge,
           --apps.irisa_otl_pkg.round_time
           NVL (((tbbde.measure)), (tbbde.stop_time - tbbde.start_time) * 24)
               adii,
           ppx.person_id,
           tbbde.approval_status
               approval_det,
           tbbde2.approval_status
               approval_day,
           hts.approval_status
               approval_timecard,
           TO_CHAR (tbbde2.start_time, 'rrrrmmdd', 'nls_calendar=persian'),
           tbbde2.start_time,
           (SELECT tap2.attribute6
              FROM apps.hxc_time_attribute_usages  taup2,
                   apps.hxc_time_attributes        tap2
             WHERE     tbbde.time_building_block_id =
                       taup2.time_building_block_id
                   AND tap2.time_attribute_id = taup2.time_attribute_id
                   AND tbbde.object_version_number =
                       taup2.time_building_block_ovn
                   AND tap2.attribute_category = 'Dummy Paexpitdff Context')
               at6,
           (SELECT tap2.attribute5
              FROM apps.hxc_time_attribute_usages  taup2,
                   apps.hxc_time_attributes        tap2
             WHERE     tbbde.time_building_block_id =
                       taup2.time_building_block_id
                   AND tap2.time_attribute_id = taup2.time_attribute_id
                   AND tbbde.object_version_number =
                       taup2.time_building_block_ovn
                   AND tap2.attribute_category = 'Dummy Paexpitdff Context')
               at5
      FROM
                hxc.hxc_time_building_blocks tbbde 
           join hxc.hxc_time_building_blocks    tbbde2 
                on  tbbde.parent_building_block_id = tbbde2.time_building_block_id
                AND tbbde.parent_building_block_ovn = tbbde2.object_version_number
           join hxc.hxc_time_building_blocks tbbde3
                on   tbbde2.parent_building_block_id = tbbde3.time_building_block_id
                AND tbbde2.parent_building_block_ovn = tbbde3.object_version_number
           join apps.hxc_time_attribute_usages  taup
                on  tbbde.time_building_block_id = taup.time_building_block_id
                AND tbbde.object_version_number = taup.time_building_block_ovn
           join apps.hxc_time_attributes        tap
                on  tap.time_attribute_id = taup.time_attribute_id
           join apps.per_all_people_f           ppx
                on  ppx.person_id = tbbde.resource_id
           join apps.per_all_assignments_f      paa
                on  paa.person_id = ppx.person_id
           join apps.hr_locations               hl
                on  paa.location_id = hl.location_id
           join apps.pa_projects_all            pp
                on  TO_NUMBER (tap.attribute1) = pp.project_id
           join apps.pa_tasks                   pt
                on  pt.project_id = pp.project_id
                AND TO_NUMBER (tap.attribute2) = pt.task_id
           join hxc.hxc_timecard_summary        hts
                on hts.timecard_id = tbbde3.time_building_block_id
                AND hts.timecard_ovn = tbbde3.object_version_number
     WHERE     1 = 1
           AND tbbde.scope = 'DETAIL'
           AND tbbde.date_to = TO_DATE ('12/31/4712', 'mm/dd/rrrr')
           AND tbbde2.date_to = TO_DATE ('12/31/4712', 'mm/dd/rrrr')
           AND tap.attribute_category = 'PROJECTS'
           AND tbbde3.scope <> 'TIMECARD_TEMPLATE'
           AND tbbde2.scope = 'DAY'
           --          AND (   TBBDE.APPROVAL_STATUS = 'APPROVED'
           --               OR tbbde2.START_TIME <
           --                     TO_DATE ('1397/04/01',
           --                              'rrrr/mm/dd',
           --                              'nls_calendar=persian'))
           AND tbbde2.start_time BETWEEN ppx.effective_start_date
                                     AND ppx.effective_end_date
           AND tbbde2.start_time BETWEEN paa.effective_start_date
                                     AND paa.effective_end_date
           AND ppx.employee_number IN
                   (SELECT employee_number FROM apps.irisa_pilot_list)
           AND tbbde2.start_time >
               TO_DATE ('1397/02/31', 'rrrr/mm/dd', 'nls_calendar=persian');


CREATE OR REPLACE SYNONYM SE_HR.IRISA_TIMECARD_DET2 FOR APPS.IRISA_TIMECARD_DET2;


GRANT SELECT ON APPS.IRISA_TIMECARD_DET2 TO HR_Q_ALL;
