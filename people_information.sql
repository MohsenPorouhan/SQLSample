/* Formatted on 07/09/2019 04:43:10 ?.? (QP5 v5.115.810.9015) */
  SELECT   papf.employee_number assignment_number--,paaf.assignment_id
           ,
           papf.FIRST_NAME,
           papf.LAST_NAME LAST_NAME,
           papf.NATIONAL_IDENTIFIER,
           papf.ATTRIBUTE2,
           papf.ATTRIBUTE1,
           TO_CHAR (ppos.date_start, 'rrrrmmdd', 'nls_calendar=persian')
              hire_date,
           paaf.EMPLOYMENT_CATEGORY,
           DECODE (
              paaf.ASSIGNMENT_TYPE,
              'E',
              apps.HR_GENERAL.DECODE_LOOKUP ('EMP_CAT',
                                             paaf.EMPLOYMENT_CATEGORY),
              'C',
              apps.HR_GENERAL.DECODE_LOOKUP ('CWK_ASG_CATEGORY',
                                             paaf.EMPLOYMENT_CATEGORY)
           )
              EMPLOYMENT_CATEGORY_MEANING,
           TO_CHAR (papf.DATE_OF_BIRTH, 'rrrrmmdd', 'nls_calendar=persian')
              DATE_OF_BIRTH,
           TO_CHAR (ppos.actual_termination_date,
                    'rrrrmmdd',
                    'nls_calendar=persian')
              actual_termination_date,
           pav.TELEPHONE_NUMBER_1,
           pav.TELEPHONE_NUMBER_3,
           papf.ATTRIBUTE16 insurance_number,
           papf.ATTRIBUTE15 insurance_Des,
           papf.ATTRIBUTE2 certificate_number,
           papf.ATTRIBUTE5 town_of_birth,
           ppei.PEI_INFORMATION1 Date_From_Military_Service,
              SUBSTR (ppei.PEI_INFORMATION2, 1, 4)
           || SUBSTR (ppei.PEI_INFORMATION2, 6, 2)
           || SUBSTR (ppei.PEI_INFORMATION2, -2)
              Date_To_Military_Service,
              SUBSTR (ppei.PEI_INFORMATION3, 1, 4)
           || SUBSTR (ppei.PEI_INFORMATION3, 6, 2)
           || SUBSTR (ppei.PEI_INFORMATION3, -2)
              Type_of_Military_Service,
           pav.ADDRESS_LINE1,
        --   employee.TOT_YEAR_REMIN_VAC_EMPL vacation_remainder,
        null vacation_remainder,
           DECODE (papf.SEX,
                   'M',
                   '1',
                   'F',
                   '2')
              Sex_Type,
           DECODE (papf.SEX,
                   'M',
                   'مرد',
                   'F',
                   'زن')
              Sex_Des,
           papf.ATTRIBUTE28 Bank_Account_Number,
           papf.ATTRIBUTE24 Parsian_Bank_number,
           papf.ATTRIBUTE26 baank_name,
           degree1.attribute1 university_level,
           TO_CHAR (degree1.ATTENDED_END_DATE, 'rrrr', 'nls_calendar=persian')
              end_date_graduated,
           degree1.attribute2 major,
           degree1.establishment university_name,
           job1.segment2 job_group,
           GDT.name job_groups,
           hlv.attribute1 work_place_code,
           hlv.ship_to_location,
           hlv.region_2,
        /*   (SELECT  DESCRIPTION
                FROM   apps.FND_FLEX_VALUES_VL
               WHERE  
         FLEX_VALUE_SET_ID = 1014932
         and FLEX_VALUE=aai.ATTRIBUTE4
        )  */
        aai.ATTRIBUTE4 flex_value,
       (
       SELECT  FLEX_VALUE_MEANING
                FROM   apps.FND_FLEX_VALUES_VL
               WHERE  
         FLEX_VALUE_SET_ID = 1014932
         and FLEX_VALUE=aai.ATTRIBUTE4
       ) flex_value_meaning1,
           Cost_Center.flex_value_meaning flex_value_meaning2,
           Cost_Center.description--,to_char(ppa.date_from,'RRRR/MM/DD','nls_calendar=persian') hire_date_from
           ,
           (SELECT   TO_CHAR (MAX (ppa2.date_from),
                              'RRRRMMDD',
                              'nls_calendar=persian')
              FROM   apps.per_person_analyses ppa2
             --,apps.per_all_people_f papf2
             WHERE   1 = 1 AND ppa2.person_id = papf.person_id
                     AND SYSDATE BETWEEN papf.effective_start_date
                                     AND  papf.effective_end_date)
              hire_date_from--,to_char(ppa.date_to,'RRRR/MM/DD','nls_calendar=persian') hire_date_to
           ,
           (SELECT   TO_CHAR (MAX (ppa2.date_to),
                              'RRRRMMDD',
                              'nls_calendar=persian')
              FROM   apps.per_person_analyses ppa2
             --,apps.per_all_people_f papf2
             WHERE   1 = 1 AND ppa2.person_id = papf.person_id
                     AND SYSDATE BETWEEN papf.effective_start_date
                                     AND  papf.effective_end_date)
              hire_date_to,
           (SELECT   COUNT (papf.person_id)
              FROM   PER_CONTACT_RELATIONSHIPS CON, HR_LOOKUPS C
             WHERE       1 = 1
                     AND papf.person_id = con.person_id(+)
                     AND con.date_end IS NULL
                     AND C.LOOKUP_TYPE = 'CONTACT'
                     AND C.LOOKUP_CODE = CON.CONTACT_TYPE
                     AND c.LOOKUP_CODE <> 'H'
                     )
              number_of_children,
           JBT.attribute2 job_cod,
           JBT.NAME JOB_NAME,
           paaf.ASS_ATTRIBUTE16 background_without_org_y,
           paaf.ASS_ATTRIBUTE29 background_without_org_m,
           paaf.ASS_ATTRIBUTE17 job_category,
           DECODE (papf.MARITAL_STATUS,
                   'M',
                   'متاهل',
                   'S',
                   'مجرد',
                   'D',
                   'معيل')
              MARITAL_STATUS,
           (SELECT   TO_CHAR (con.date_start,
                              'rrrrmmdd',
                              'nls_calendar=persian')
              FROM   PER_CONTACT_RELATIONSHIPS CON--, HR_LOOKUPS C
             WHERE       1 = 1
                     AND papf.person_id = con.person_id(+)
                   --  AND C.LOOKUP_TYPE = 'CONTACT'
                    -- AND C.LOOKUP_CODE = CON.CONTACT_TYPE
                     AND con.date_end IS NULL
                     AND contact_type = 'H'
                   --  AND c.meaning = '????'     
                     )
              marriage_date,
           apps.get_save_sanavat_y (
              paaf.assignment_id,
              TO_DATE ('1394/05/01', 'rrrr/mm/dd', 'nls_calendar=persian'),
              TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian')
           )
              save_sanavat_y,
           apps.get_save_sanavat_m (
              paaf.assignment_id,
              TO_DATE ('1394/05/01', 'rrrr/mm/dd', 'nls_calendar=persian'),
              TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian')
           )
              save_sanavat_m,
          nvl( apps.payroll_result_value6 (
              TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
              4851,
              paaf.assignment_id,
              'Input Value',
              15102
           ),0)+nvl( apps.payroll_result_value6 (
              TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
              5257,
              paaf.assignment_id,
              'Actual Value',
              15102
           ),0)
              base_payroll,
           apps.payroll_result_value6 (
              TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
              4731,
              paaf.assignment_id,
              'Actual Value',
              15102
           )
              sanavat_payroll,
           apps.payroll_result_value6 (
              TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
              5299,
              paaf.assignment_id,
              'Actual Value',
              15102
           )
              expert_payroll,
           apps.payroll_result_value6 (
              TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
              5302,
              paaf.assignment_id,
              'Actual Value',
              15102
           )
              job_payroll,
           apps.payroll_result_value6 (
              TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
              4729,
              paaf.assignment_id,
              'Actual Value',
              15102
           )
              isar_payroll,
           paaf.ASS_ATTRIBUTE14 contract_assign_number,
           papf.ATTRIBUTE19 RFID,
           papf.ATTRIBUTE23 certificate_serial,
           paaf.ASS_ATTRIBUTE5 insurance_place_code,
           (SELECT   REGION_2
              FROM   hr_locations_all
             WHERE   location_id = paaf.ASS_ATTRIBUTE5)
              insurance_place_desc,
           papf.ATTRIBUTE4 town_of_export_certificate,
              SUBSTR (papf.ATTRIBUTE14, 1, 4)
           || SUBSTR (papf.ATTRIBUTE14, 6, 2)
           || SUBSTR (papf.ATTRIBUTE14, -2)
              export_date,
           PAPF.TOWN_OF_BIRTH TOWN_OF_BIRTH2-- ,round((apps.irisa_payroll_pkg.get_balance_value(81,paaf.assignment_id,'INCLUSIVE_RECURING_ASG_RUN',TO_DATE (:end_date,
                                            --                    'rrrrmmdd',
                                            --                    'NLS_CALENDAR=PERSIAN'),TO_DATE (:end_date,
                                            --                    'rrrrmmdd',
                                            --                    'NLS_CALENDAR=PERSIAN'))/191)* 1.4)
           ,
 (apps.irisa_payroll_pkg.get_balance_value4(81, paaf.assignment_id,8080,TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'))/191)*1.4
              over_time_hour,
           ROUND( (apps.payroll_result_value6 (
                      TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
                      5257,
                      paaf.assignment_id,
                      'Actual Value',
                      15102
                   )
                   + apps.payroll_result_value6 (
                        TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
                        4731,
                        paaf.assignment_id,
                        'Actual Value',
                        15102
                     )
                   + apps.payroll_result_value6 (
                        TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
                        5299,
                        paaf.assignment_id,
                        'Actual Value',
                        15102
                     )
                   + apps.payroll_result_value6 (
                        TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
                        5302,
                        paaf.assignment_id,
                        'Actual Value',
                        15102
                     )
                   + apps.payroll_result_value6 (
                        TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
                        4729,
                        paaf.assignment_id,
                        'Actual Value',
                        15102
                     ))
                 / 30)
              mission_hour,
           (SELECT                                  --         paaf.person_id,
                  hou.ORGANIZATION_ID org_id
              --hou.name
              FROM   hr_organization_units hou
             WHERE   1 = 1
                     AND hou.ORGANIZATION_ID =
                           apps.get_bu_orgid (
                              TO_DATE (:end_date,
                                       'rrrrmmdd',
                                       'nls_calendar=persian'),
                              NVL (paaf.ASS_ATTRIBUTE20, paaf.ORGANIZATION_ID)
                           ))
              parent_org_id,
           (SELECT                                  --         paaf.person_id,
                     --         hou.ORGANIZATION_ID org_id,
                     hou.name
              FROM   hr_organization_units hou
             WHERE   1 = 1
                     AND hou.ORGANIZATION_ID =
                           apps.get_bu_orgid (
                              TO_DATE (:end_date,
                                       'rrrrmmdd',
                                       'nls_calendar=persian'),
                              NVL (paaf.ASS_ATTRIBUTE20, paaf.ORGANIZATION_ID)
                           ))
              parent_org,
           (SELECT                                  --         paaf.person_id,
                  hou.name
              --hou.name
              FROM   hr_organization_units hou
             WHERE   1 = 1 AND hou.ORGANIZATION_ID = paaf.ASS_ATTRIBUTE20)
              reward_org,
           (SELECT                                  --         paaf.person_id,
                  hou.name
              --hou.name
              FROM   hr_organization_units hou
             WHERE   1 = 1 AND hou.ORGANIZATION_ID = paaf.ORGANIZATION_ID)
              org_name,
           apps.irisa_payroll_pkg.nonrec_entry (
              paaf.assignment_id,
              4851,
              319,
              TO_DATE (:end_date, 'rrrrmmdd', 'NLS_CALENDAR=PERSIAN')
           )
              daily_base,
           apps.payroll_result_value6 (
              TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
              7184,
              paaf.assignment_id,
              'Actual Value',
              15102
           )
              shayestegi,
           apps.payroll_result_value6 (
              TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
              7185,
              paaf.assignment_id,
              '????_???',
              15102
           )
              sh_gradej,
           apps.payroll_result_value6 (
              TO_DATE (:end_date, 'rrrrmmdd', 'nls_calendar=persian'),
              7186,
              paaf.assignment_id,
              '????_????',
              15102
           )
              sh_grade,
           TRUNC( ( ( (NVL (paaf.ASS_ATTRIBUTE16, 0)
                       + NVL (paaf.ASS_ATTRIBUTE27, 0))
                     * 365)
                   + (CASE
                         WHEN paaf.ASS_ATTRIBUTE27 >= 0
                         THEN
                            (NVL (paaf.ASS_ATTRIBUTE29, 0)
                             + NVL (paaf.ASS_ATTRIBUTE30, 0))
                         ELSE
                            (NVL (paaf.ASS_ATTRIBUTE29, 0)
                             + NVL (paaf.ASS_ATTRIBUTE30, 0) * (-1))
                      END
                      * 30)
                   + NVL (
                        DECODE (
                           ppei.PEI_INFORMATION7,
                           'بله',
                           TO_DATE (ppei.PEI_INFORMATION3,
                                    'rrrr/mm/dd',
                                    'nls_calendar=persian')
                           - TO_DATE (ppei.PEI_INFORMATION2,
                                      'rrrr/mm/dd',
                                      'nls_calendar=persian')
                           + 1
                        ),
                        0
                     )
                   + (NVL (
                         ppos.actual_termination_date,
                         (SELECT   MAX (ppa.EFFECTIVE_DATE) --,ptp.PERIOD_NAME
                            FROM   hr.pay_payroll_actions ppa,
                                   hr.per_time_periods ptp,
                                   pay_payroll_actions_v ppav
                           WHERE   1 = 1
                                   AND ptp.TIME_PERIOD_ID = ppa.time_period_id
                                   AND ppav.payroll_action_id =
                                         ppa.payroll_action_id
                                  -- AND ppav.name LIKE ('%???? ???????%')
                                  and PPAV.ELEMENT_SET_ID=9102
                                   AND ppa.EFFECTIVE_DATE >
                                         TO_DATE ('03/19/2016', 'mm/dd/yyyy'))
                      )
                      - ppos.date_start
                      + 1))
                 / 365)
              background_org_y,
           ROUND(MOD (
                    ( (NVL (paaf.ASS_ATTRIBUTE16, 0)
                       + NVL (paaf.ASS_ATTRIBUTE27, 0))
                     * 365)
                    + (CASE
                          WHEN paaf.ASS_ATTRIBUTE27 >= 0
                          THEN
                             (NVL (paaf.ASS_ATTRIBUTE29, 0)
                              + NVL (paaf.ASS_ATTRIBUTE30, 0))
                          ELSE
                             (NVL (paaf.ASS_ATTRIBUTE29, 0)
                              + NVL (paaf.ASS_ATTRIBUTE30, 0) * (-1))
                       END
                       * 30)
                    + NVL (
                         DECODE (
                            ppei.PEI_INFORMATION7,
                            'بله',
                            TO_DATE (ppei.PEI_INFORMATION3,
                                     'rrrr/mm/dd',
                                     'nls_calendar=persian')
                            - TO_DATE (ppei.PEI_INFORMATION2,
                                       'rrrr/mm/dd',
                                       'nls_calendar=persian')
                            + 1
                         ),
                         0
                      )
                    + (NVL (
                          ppos.actual_termination_date,
                          (SELECT   MAX (ppa.EFFECTIVE_DATE) --,ptp.PERIOD_NAME
                             FROM   hr.pay_payroll_actions ppa,
                                    hr.per_time_periods ptp,
                                    pay_payroll_actions_v ppav
                            WHERE   1 = 1
                                    AND ptp.TIME_PERIOD_ID = ppa.time_period_id
                                    AND ppav.payroll_action_id =
                                          ppa.payroll_action_id
                                    --AND ppav.name LIKE ('%???? ???????%')
                                    and ppav.element_set_id=9102
                                    AND ppa.EFFECTIVE_DATE >
                                          TO_DATE ('03/19/2016', 'mm/dd/yyyy'))
                       )
                       - ppos.date_start
                       + 1),
                    365
                 )
                 / 31)
              background_org_m,
           paaf.ASS_ATTRIBUTE24 M_z,
           paaf.ASS_ATTRIBUTE25 K_z
    FROM   hr.per_all_people_f papf,
           apps.per_all_assignments_f paaf,
           PER_PERIODS_OF_SERVICE ppos--,PER_PERSON_TYPE_USAGES_F pptuf
           ,
          pay_assignment_actions paa,
    pay_payroll_actions ppa,
           PER_ADDRESSES_V pav,
           (SELECT   *
              FROM   PER_PEOPLE_EXTRA_INFO
             WHERE   PEI_INFORMATION_CATEGORY = 'IRISA_MILITARY') ppei,
       --    ofc.employee,
           (SELECT   pea.*, ppm.*, ppm.EXTERNAL_ACCOUNT_ID pp
              FROM   PAY_PERSONAL_PAYMENT_METHODS_F PPM,
                     PAY_EXTERNAL_ACCOUNTS PEA
             WHERE   PEA.EXTERNAL_ACCOUNT_ID = PPM.EXTERNAL_ACCOUNT_ID
                     AND TO_DATE (:end_date,
                                  'rrrrmmdd',
                                  'NLS_CALENDAR=PERSIAN') BETWEEN PPM.effective_start_date
                                                              AND  PPM.effective_end_date)
           bank,
           (SELECT   *
              FROM   PER_ESTABLISHMENT_ATTEND_V peav
             WHERE   ATTENDED_END_DATE =
                        (SELECT   MAX(NVL (
                                         ATTENDED_END_DATE,
                                         TO_DATE ('12/31/4712', 'mm/dd/yyyy')
                                      ))
                           FROM   PER_ESTABLISHMENT_ATTEND_V peav2
                          WHERE   peav.person_id = peav2.person_id)) degree1,
           (SELECT   *
              FROM   PER_JOBS_VL pjv, per_job_definitions pjd
             WHERE   pjv.job_definition_id = PJD.JOB_DEFINITION_ID) job1,
           PER_GRADES_TL GDT,
           HR_LOCATIONS_V hlv,
--           (  SELECT   *
--                FROM   apps.FND_FLEX_VALUES_VL
--               WHERE   ( ('' IS NULL)
--                        OR (structured_hierarchy_level IN
--                                  (SELECT   hierarchy_id
--                                     FROM   apps.fnd_flex_hierarchies_vl h
--                                    WHERE   h.flex_value_set_id = 1014932
--                                            AND h.hierarchy_name LIKE '')))
--                       AND (FLEX_VALUE_SET_ID = 1014932)
--            ORDER BY   flex_value) value_set,
           (SELECT   *
              FROM   apps.PAY_COST_ALLOCATION_KEYFLEX PCAF,
                     apps.PAY_COST_ALLOCATIONS_F PAY,
                     apps.FND_FLEX_VALUES_VL ffvv
             WHERE   1 = 1
                     AND PCAF.COST_ALLOCATION_KEYFLEX_ID(+) =
                           PAY.COST_ALLOCATION_KEYFLEX_ID
                     AND ffvv.flex_value = PCAF.segment3
                     AND ( ('' IS NULL)
                          OR (structured_hierarchy_level IN
                                    (SELECT   hierarchy_id
                                       FROM   apps.fnd_flex_hierarchies_vl h
                                      WHERE   h.flex_value_set_id = 1014918
                                              AND h.hierarchy_name LIKE '')))
                     AND (FLEX_VALUE_SET_ID = 1014918)
                     AND TO_DATE (:end_date,
                                  'rrrrmmdd',
                                  'NLS_CALENDAR=PERSIAN') BETWEEN PAY.effective_start_date
                                                              AND  PAY.effective_end_date)
           Cost_Center--,apps.per_person_analyses ppa
           ,
           PER_JOBS JBT,
(select * from         
  apps.hxt_add_assign_info_f aai2
           where
              TO_DATE (:end_date, 'rrrrmmdd', 'NLS_CALENDAR=PERSIAN') BETWEEN aai2.EFFECTIVE_START_DATE and aai2.EFFECTIVE_end_DATE
            )aai
   WHERE       1 = 1
           AND papf.person_id = paaf.person_id
           --and papf.person_id=pptuf.person_id
           AND ppos.person_id = paaf.person_id
           AND pav.person_id(+) = papf.person_id
           AND ppei.person_id(+) = papf.person_id
           AND bank.assignment_id(+) = paaf.assignment_id
    and paa.assignment_id(+)=paaf.assignment_id
    and ppa.payroll_action_id=paa.payroll_action_id
    and  ppa.action_type in('R')
          and ppa.ELEMENT_SET_ID in(15102)
          and TO_DATE (:end_date, 'rrrrmmdd', 'NLS_CALENDAR=PERSIAN')=ppa.effective_date
    and (ppa.effective_date) between paaf.effective_start_date and  paaf.effective_end_date
    and (ppa.effective_date) between papf.effective_start_date and  papf.effective_end_date
        --   AND TO_CHAR (employee.NUM_PRSN_EMPL) = papf.employee_number
           AND degree1.person_id(+) = papf.person_id
           --and papf.person_id=ppa.person_id(+)
           AND job1.JOB_ID(+) = paaf.job_id
           AND GDT.grade_id(+) = paaf.grade_id
           AND hlv.location_id(+) = paaf.location_id
       --    AND value_set.flex_value(+) =aai.ATTRIBUTE4
           AND Cost_Center.ASSIGNMENT_ID(+) = PAAF.ASSIGNMENT_ID
           --and pptuf.person_type_id=1120
           --and pptuf.person_type_id<>3118
           AND paaf.assignment_number NOT IN ('792992', '792900')
           AND paaf.JOB_ID = JBT.JOB_ID(+)
           --and paaf.effective_end_date=(select max(paaf2.effective_end_date) from apps.per_all_assignments_f paaf2 where paaf2.person_id=paaf.person_id)
           --and papf.effective_end_date=(select max(papf2.effective_end_date) from apps.per_all_people_f papf2 where papf2.person_id=papf.person_id)
           --and pptuf.effective_end_date=(select max(pptuf2.effective_end_date) from apps.PER_PERSON_TYPE_USAGES_F pptuf2 where pptuf2.person_id=papf.person_id)
           AND paaf.primary_flag = 'Y'
           and aai.ASSIGNMENT_ID(+)=paaf.ASSIGNMENT_ID      
           AND TO_DATE (:end_date, 'rrrrmmdd', 'NLS_CALENDAR=PERSIAN') BETWEEN ppos.date_start
                                                                           AND  NVL (
                                                                                   ppos.actual_termination_date,
                                                                                   TO_DATE (
                                                                                      '12/31/4712',
                                                                                      'mm/dd/yyyy'
                                                                                   )
                                                                                )
           AND TO_DATE (:end_date, 'rrrrmmdd', 'NLS_CALENDAR=PERSIAN') BETWEEN paaf.effective_start_date
                                                                           AND  paaf.effective_end_date
           AND TO_DATE (:end_date, 'rrrrmmdd', 'NLS_CALENDAR=PERSIAN') BETWEEN papf.effective_start_date
                                                                           AND  papf.effective_end_date
           --     and
           --         TO_DATE (:end_date,
           --                    'rrrrmmdd',
           --                    'NLS_CALENDAR=PERSIAN')
           --           BETWEEN pptuf.effective_start_date and pptuf.effective_end_date
--------------------------------------------------------           AND paaf.EMPLOYMENT_CATEGORY IN (:P_EMPTYPE)
ORDER BY   papf.employee_number