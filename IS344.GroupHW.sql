--Group 3: Stacey Ibe, Alison Von Haden, Molly Brewer, Brandon Simonis, Jamie Berger
--Group HW
--Jean Pratt
--May 4, 2018


--Drop tables plus cascade constraints
DROP TABLE email CASCADE CONSTRAINTS;
DROP TABLE teacher CASCADE CONSTRAINTS;
DROP TABLE address CASCADE CONSTRAINTS;
DROP TABLE phone CASCADE CONSTRAINTS;    
DROP TABLE org CASCADE CONSTRAINTS;
DROP TABLE person_org CASCADE CONSTRAINTS;
DROP TABLE mbr CASCADE CONSTRAINTS;
DROP TABLE services CASCADE CONSTRAINTS;
DROP TABLE services_provided CASCADE CONSTRAINTS;
DROP TABLE services_used CASCADE CONSTRAINTS;
DROP TABLE authorized_individual CASCADE CONSTRAINTS;
DROP TABLE consentform CASCADE CONSTRAINTS;
DROP TABLE memberreleaseform CASCADE CONSTRAINTS;
DROP TABLE dobirth CASCADE CONSTRAINTS;
DROP TABLE ethnicity CASCADE CONSTRAINTS;
DROP TABLE member_ethnicity CASCADE CONSTRAINTS;
DROP TABLE familyinfo CASCADE CONSTRAINTS;
DROP TABLE attendance CASCADE CONSTRAINTS;
DROP TABLE academic_info CASCADE CONSTRAINTS;
DROP TABLE hw CASCADE CONSTRAINTS;
DROP TABLE allergy CASCADE CONSTRAINTS;
DROP TABLE truancy CASCADE CONSTRAINTS;
DROP TABLE socialdev CASCADE CONSTRAINTS;
DROP TABLE medical_history CASCADE CONSTRAINTS;
DROP TABLE medication CASCADE CONSTRAINTS;
DROP TABLE healthcondition CASCADE CONSTRAINTS;
DROP TABLE mbr_health_condition CASCADE CONSTRAINTS;
DROP TABLE medstaff CASCADE CONSTRAINTS;
DROP TABLE mbrmedinfo CASCADE CONSTRAINTS;
DROP TABLE paymentinfo CASCADE CONSTRAINTS;
DROP TABLE person CASCADE CONSTRAINTS;
DROP TABLE person_phone CASCADE CONSTRAINTS; 

--The code below drops the member_medication view
DROP VIEW member_medications CASCADE CONSTRAINTS;

--Drop statments for Sequences
DROP SEQUENCE seqpersonid;
DROP SEQUENCE seqaddressid;
DROP SEQUENCE seqphoneid;
DROP SEQUENCE seqord_id;
DROP SEQUENCE dobirthseq;
DROP SEQUENCE academicinformationseq;
DROP SEQUENCE socialdevseq;
DROP SEQUENCE seqconid;
DROP SEQUENCE seqhealthcondid;
DROP SEQUENCE seqmedicationid;
DROP SEQUENCE mbrrlsfrm_seq;
DROP SEQUENCE sevicesseq;
DROP SEQUENCE seqfamid;
DROP SEQUENCE attendanceseq;
DROP SEQUENCE seqethnicity;

--The code below creates a table for Person where personid is the primary key
CREATE TABLE person(
  personid NUMBER(6) NOT NULL,
  lname    VARCHAR2(35) NOT NULL,
  fname    VARCHAR2(35) NOT NULL,
  mname    VARCHAR2 (35),
  CONSTRAINT personid_pk PRIMARY KEY (personid));
  
--The code below creates a table for Email where personid is the primary key and foreign key
CREATE TABLE email (
  personid NUMBER(6) NOT NULL,
  email_add VARCHAR2(35) NOT NULL,
  CONSTRAINT email_pk PRIMARY KEY (personid),
  CONSTRAINT email_fk FOREIGN KEY (personid) REFERENCES person (personid));

  

--The code below creates table for Date of Birth where birthid is the primary key
CREATE TABLE dobirth (
  birthid   NUMBER (6) NOT NULL,
  dob       DATE NOT NULL,
  CONSTRAINT dobirth_pk PRIMARY KEY (birthid));

--The code below creates the table for Family Information where famid is the primary key
--Check constraint for liveswith, 'B'= Both Parents, 'M'= Mother, 'F'= Father, 'GP'= Grandparent(s), 
--'G'=Guardian(s), 'R'= Relative(s), 'FP'= Foster Parent(s)
--Check constraint for free_lunch, 'Y'= Yes, eligible for reduced/free lunch, and 'N' = no, not eligible for reduced/free lunch
CREATE TABLE familyinfo (
  famid     NUMBER (6) NOT NULL,
  famsize   NUMBER (20) NOT NULL,
  famincome NUMBER (10) NOT NULL,
  liveswith VARCHAR2 (2) NOT NULL,
  free_lunch CHAR (1) NOT NULL,
  mil_b_name VARCHAR2 (25) DEFAULT 'None' NOT NULL,
  CONSTRAINT familyinfo_lives_cc CHECK (liveswith IN ('B', 'M', 'F', 'GP', 'G', 'R', 'FP')),
  CONSTRAINT free_lunch_cc CHECK (free_lunch IN ('Y','N')),
  CONSTRAINT familyinfo_pk PRIMARY KEY (famid));
  
--The code below creates the Phone table where phoneid is the primary key. 
--Check constraint for ptype: 'M'= Mobile, 'H'= Home, 'W' = Work
CREATE TABLE phone (
  phoneid NUMBER (6) NOT NULL,
  pnumber NUMBER (10) NOT NULL,
  ptype  CHAR (1) NOT NULL,
  CONSTRAINT phone_ptype_cc CHECK ((ptype='C') OR (ptype='H') OR (ptype='W')),
  CONSTRAINT phone_phoneid_pk PRIMARY KEY (phoneid));
  
  --The code below creates the Personphone table which is the associative table that connects phone and person where phonid and personid are the primary and foreign keys
CREATE TABLE person_phone (
  phoneid NUMBER (6) NOT NULL,
  personid NUMBER (6) NOT NULL, 
  CONSTRAINT person_phone_pk PRIMARY KEY (phoneid, personid),
  CONSTRAINT personphone_personid_fk FOREIGN KEY (personid) REFERENCES person (personid),
  CONSTRAINT personphone_phoneid_fk FOREIGN KEY (phoneid) REFERENCES phone (phoneid));

--The code below creates the Address table where addrid is the primary key
CREATE TABLE address (
  addrid NUMBER (6) NOT NULL,
  strt VARCHAR2 (35) NOT NULL,
  city VARCHAR2 (35) NOT NULL,
  ste CHAR (2) DEFAULT 'WI' NOT NULL,
  zipcode VARCHAR2 (10) NOT NULL,
  CONSTRAINT addr_addrid1_pk PRIMARY KEY(addrid));
  
--The code below creates table for Member where memberid is the primary key
--Constraint for gender; M= Male, F= Female, O= Other
CREATE TABLE mbr (
  memberid    NUMBER (6) NOT NULL,
  gender      CHAR(1),
  birthid     NUMBER(6) NOT NULL,
  famid       NUMBER(6) NOT NULL,
  mbraddrid   NUMBER (6) NOT NULL,
  CONSTRAINT membergender_cc CHECK (gender IN ('M','F','O')),
  CONSTRAINT mbr_memberid_pk PRIMARY KEY (memberid),
  CONSTRAINT mbr_memberid_fk FOREIGN KEY (memberid) REFERENCES person (personid),
  CONSTRAINT mbr_birthid_fk FOREIGN KEY (birthid) REFERENCES dobirth (birthid),
  CONSTRAINT mbr_famid_fk FOREIGN KEY (famid) REFERENCES familyinfo (famid),
  CONSTRAINT mbr_mbraddrid_fk FOREIGN KEY (mbraddrid) REFERENCES address (addrid));
  
  
--The code below creates table for Authorized Individual where authorizedindid and memberid are the primary and foreign keys
--Constraint for gender; M= Male, F= Female, O= Other
--Check constraints are for emergency contact, authorized to pick up, head of the house hold and edit account information
--These constraints are all yes or no questions,so 'Y'= yes and n= 'N'
CREATE TABLE authorized_individual (
  authorizedindid NUMBER(6) NOT NULL,
  memberid        NUMBER(6) NOT NULL,
  gender          CHAR(1),
  relationship    VARCHAR2(35) NOT NULL,
  headofhouse     CHAR(1) NOT NULL,
  emg_cont        CHAR(1) NOT NULL,
  auth_pickup     CHAR(1) NOT NULL,
  edit_acct_info  CHAR(1) NOT NULL,
  authaddrid          NUMBER (6) NOT NULL,
  authphoneid         NUMBER (6) NOT NULL,
  CONSTRAINT authorizedindgender_cc CHECK (gender IN ('M','F','O')),
  CONSTRAINT authorized_emg_cont_cc CHECK (emg_cont IN ('Y', 'N')),
  CONSTRAINT authorized_individual_cc CHECK (auth_pickup IN ('Y', 'N')),
  CONSTRAINT authorized_headofhouse_cc CHECK (headofhouse IN ('Y', 'N')),
  CONSTRAINT authorized_edit_acct_info_cc CHECK (edit_acct_info IN ('Y', 'N')),
  CONSTRAINT authorizedmemberid_pk PRIMARY KEY (authorizedindid, memberid),
  CONSTRAINT authorizedindid_fk FOREIGN KEY (authorizedindid) REFERENCES person (personid),
  CONSTRAINT authorizedmemberid_fk FOREIGN KEY (memberid) REFERENCES person (personid),
  CONSTRAINT authroziedid_addr_fk FOREIGN KEY (authaddrid) REFERENCES address (addrid),
  CONSTRAINT authorizedmemberid_phoneid_fk FOREIGN KEY (authphoneid) REFERENCES phone (phoneid));
  
--The code below creates the table for ethnicity where ethnicityid is the primary key in the table
--Check Constraint for ethnicity 'C'= Caucasian, 'AA' = African American, 'AI' = American Indian, 'AP' = Asian-Asian Pacific,
--'HP' = Hispanic-Latino, 'ME' = Multi-Ethnic, 'O'= Other
CREATE TABLE ethnicity (
  ethnicityid     NUMBER (6) NOT NULL,
  ethnicity_type  VARCHAR2(35) NOT NULL,
  CONSTRAINT ethnicity_type_cc CHECK (ethnicity_type IN ('C', 'AA','AI','AP','HP','ME','O')),
  CONSTRAINT ethnicity_ethnicityid_pk PRIMARY KEY (ethnicityid));
  
--The code below creates the table for member_ethnicity where ethnicityid and memberid is the primary and foriegn keys in the table
CREATE TABLE member_ethnicity (
  memberid        NUMBER (6) NOT NULL,
  ethnicityid     NUMBER (6) NOT NULL,
  CONSTRAINT ethnicity_pk PRIMARY KEY (ethnicityid, memberid),
  CONSTRAINT ethnicity_fk FOREIGN KEY (ethnicityid) REFERENCES ethnicity (ethnicityid),
  CONSTRAINT memberid_fk FOREIGN KEY (memberid) REFERENCES mbr (memberid));

  
--The code below creates the table for attendance where attendance_id is the primary key and
--memberid is the foreign key
CREATE TABLE attendance (
  attendance_id NUMBER (6) NOT NULL,
  check_in    DATE NOT NULL,
  check_out   DATE NOT NULL,
  ch_in_out_day DATE NOT NULL,
  memberid    NUMBER (6) NOT NULL,
  CONSTRAINT attendance_pk PRIMARY KEY (attendance_id),
  CONSTRAINT attendance_fk FOREIGN KEY (memberid) REFERENCES mbr (memberid));

--The code below creates the table for Truancy where memberid is the primary key and foreign key  
CREATE TABLE truancy (
  memberid NUMBER (6) NOT NULL,
  truancy_desc VARCHAR (35) NOT NULL,
  CONSTRAINT truancy_pk PRIMARY KEY (memberid),
  CONSTRAINT truancy_fk FOREIGN KEY (memberid) REFERENCES mbr (memberid));

--The code below creates the table for academic_info where membrerid is the primary key and foreign key
--Since we update this each year we will update the students grades and if their parents are satisfied each year
CREATE TABLE academic_info (
  academicid NUMBER (6) NOT NULL,
  memberid   NUMBER (6) NOT NULL,
  grade      VARCHAR2 (50) NOT NULL,
  g_satis    CHAR (1) NOT NULL,
  held_back  CHAR (1) NOT NULL,
  schoolyear VARCHAR2 (2) NOT NULL,
  CONSTRAINT g_statis_cc CHECK (g_satis IN ('Y', 'N')),
  CONSTRAINT held_back_cc CHECK (held_back IN ('Y', 'N')),
  CONSTRAINT academic_info_pk PRIMARY KEY (academicid),
  CONSTRAINT academic_memberid_fk FOREIGN KEY (memberid) REFERENCES mbr (memberid)); 

  
-- The code below creates the table for Organization where org_id is the primary key
CREATE TABLE org (
  org_id  NUMBER(6) NOT NULL,
  org_name VARCHAR2(35) NOT NULL,
  fd_phone NUMBER (10) NOT NULL,
  CONSTRAINT org_org_id_pk PRIMARY KEY (org_id));

--The code below creates the table for Person_Org where org_id and personid are the primary and foreign keys
CREATE TABLE person_org (
  personid NUMBER(6) NOT NULL,
  org_id  NUMBER(6) NOT NULL,
  CONSTRAINT person_org_pk PRIMARY KEY (personid, org_id),
  CONSTRAINT person_org_person_fk FOREIGN KEY (personid) REFERENCES person (personid),
  CONSTRAINT person_org_org_fk FOREIGN KEY (org_id) REFERENCES org (org_id));

--The code below creates the table for Teacher where personid and teacherid are the primary and foreign keys
--The check constraint in this table to make sure they are entering a a valid school year
--'PK'= preschool,'4K'= 4k, '5K'= 5k, '1'= 1st grade, '2'=2nd grade,'3'= 3rd grade,'4'= 4th grade,'5'= 5th grade,
--'6'= 6th grade,'7'= 7th grade,'8'= 8th grade,'FR'= Freshman,'SO'= Sophmore,'JR'= Junior,'SR'= Senior
CREATE TABLE teacher (
  personid NUMBER (6) NOT NULL,
  teacherid NUMBER (6) NOT NULL,
  schoolyear VARCHAR(2) NOT NULL,
  fallacademicyear DATE NOT NULL,
  springacademicyear DATE NOT NULL,
  CONSTRAINT teacher_schoolyear_cc CHECK (schoolyear IN ('PK','4K', '5K', '1', '2','3','4','5','6','7','8','FR','SO','JR','SR')),
  CONSTRAINT teacher_pk PRIMARY KEY (personid, teacherid),
  CONSTRAINT teacher_person_fk FOREIGN KEY (personid) REFERENCES person (personid),
  CONSTRAINT teacher_teacher_fk FOREIGN KEY (personid) REFERENCES person (personid));

--The code below creates the table for Member Release Form where memberid and authorized individualids are the primary and foreign keys
--Check constraints for liability, transportation, photo_video, academics, computer policy, and electronics "Y" = Yes, understood
--and "N" = No,did not understand
--Check constraint for computer access is "Y"= Yes, they have permission to access computers or "N" No, they do not give permission to access computers
--Check constraint for authorized to leave is "A"= Authorized to leave unescorted or "U" = Unauthorized to leave unescorted
CREATE TABLE memberreleaseform (
  release_form_id NUMBER(6) NOT NULL,
  liability CHAR (1) DEFAULT 'Y' NOT NULL,
  transportation CHAR (1) DEFAULT 'Y' NOT NULL,
  photo_video CHAR (1) DEFAULT 'Y' NOT NULL,
  academics CHAR (1) DEFAULT 'Y' NOT NULL,
  computer_policy CHAR (1) DEFAULT 'Y' NOT NULL,
  computer_access CHAR (1) NOT NULL,
  leave_club CHAR (1) NOT NULL,
  electronics CHAR (1) DEFAULT 'N' NOT NULL,
  memberdatesigned DATE NOT NULL,
  authorizedinddatesigned DATE NOT NULL,
  memberid NUMBER (6) NOT NULL,
  authorizedindid NUMBER (6) NOT NULL,
  CONSTRAINT liability_CC CHECK (liability IN ('Y', 'N')),
  CONSTRAINT transportation_CC CHECK (transportation IN ('Y', 'N')),
  CONSTRAINT phot_video_CC CHECK (photo_video IN ('Y', 'N')),
  CONSTRAINT acedmics_CC CHECK (academics IN ('Y', 'N')),
  CONSTRAINT computer_policy_CC CHECK (computer_policy IN ('Y', 'N')),
  CONSTRAINT computer_access_CC CHECK (computer_access IN ('Y', 'N')),
  CONSTRAINT leave_club_CC CHECK (leave_club IN ('A', 'U')),
  CONSTRAINT electronics_CC CHECK (electronics IN ('Y', 'N')),
  CONSTRAINT memberreleaseform_pk PRIMARY KEY (release_form_id),
  CONSTRAINT memberreleaseform_member_fk FOREIGN KEY (memberid) REFERENCES person (personid),
  CONSTRAINT memberrealease_authorized_fk FOREIGN KEY (authorizedindid) REFERENCES person (personid));
 
  
--The code below creates the table for homework(hw) where hw_id is the primary key
CREATE TABLE hw (
  hw_id NUMBER (6) NOT NULL,
  hw_desc VARCHAR2(35) NOT NULL,
  CONSTRAINT hw_pk PRIMARY KEY (hw_id));
  
  --The code below creates the table for Services where servicesid is the primary key
CREATE TABLE services (
  servicesid NUMBER(6),
  servicename VARCHAR2 (35) NOT NULL,
  CONSTRAINT services_servicesid_PK PRIMARY KEY (servicesid));

--The table below creates Services provided M:M Table where schoolid and servicesid becomes the primary and foreign keys
CREATE TABLE services_provided (
  schoolid NUMBER (6),
  servicesid NUMBER (6),
  CONSTRAINT servicesprov_school_pk PRIMARY KEY (schoolid, servicesid),
  CONSTRAINT servicesprov_school1_person_fk FOREIGN KEY (schoolid) REFERENCES org (org_id),
  CONSTRAINT servicesprov_service_org_fk FOREIGN KEY (servicesid) REFERENCES services (servicesid));
  
--The code below creates the services_used table where the memberid and servicesid becomes the primary and foreign keys
CREATE TABLE services_used(
    memberid NUMBER (6),
    servicesid NUMBER (6),
    CONSTRAINT servicesused_memberid_PK PRIMARY KEY (memberid,servicesid),
    CONSTRAINT servicesused_memberidfk FOREIGN KEY (memberid) REFERENCES mbr (memberid),
    CONSTRAINT servicesused_servicesid_fk FOREIGN KEY (servicesid) REFERENCES services (servicesid));
    
--The code below creates the table for Medical History where memberid is the primary and foreign key
--Check constraint for immunization and counseling, "Y"= Yes and "N"= No
CREATE TABLE medical_history (
  memberid NUMBER(6) NOT NULL,
  l_wellchild DATE NOT NULL,
  immunizations CHAR(1) NOT NULL,
  rec_counseling CHAR(1) NOT NULL,
  CONSTRAINTS immunizations_cc CHECK (immunizations IN ('Y', 'N')),
  CONSTRAINTS rec_counseling_cc CHECK (rec_counseling IN ('Y', 'N')),
  CONSTRAINT medical_history_pk PRIMARY KEY (memberid),
  CONSTRAINT medical_history_fk FOREIGN KEY (memberid) REFERENCES mbr (memberid));

--The code below creates the table for Allergy where memberid is the primary key and foreign key
CREATE TABLE allergy (
  memberid NUMBER (6) NOT NULL,
  all_desc VARCHAR2(50) NOT NULL,
  CONSTRAINT allergy_pk PRIMARY KEY (memberid),
  CONSTRAINT allergy_fk FOREIGN KEY (memberid) REFERENCES mbr (memberid));
  
--The code below creates the table for Consent Form where conid is the primary key and foreign keys are memberid, authorizedindid and staffid
--Check constraint for memberstatus: 'G'= Guest, 'N'= New Member,'R'= Returning Member
--Check constraint for completedorient: Y = Completed, N= Not completed
CREATE TABLE consentform (
    conid NUMBER (6) NOT NULL,
    memberstatus CHAR(1) NOT NULL,
    datedataentered DATE NOT NULL,
    orienschedule DATE NOT NULL,
    orientationtime DATE NOT NULL,
    completedorient CHAR(1) NOT NULL,
    memberid NUMBER (6) NOT NULL,
    authorizedindid NUMBER (6),
    staffid NUMBER (6) NOT NULL,
    CONSTRAINT consentformmemberstatus_cc CHECK (memberstatus IN ('G', 'N','R')),
    CONSTRAINT completedorient_cc CHECK (completedorient IN ('Y', 'N')),
    CONSTRAINT consentform_conid_pk PRIMARY KEY (conid),
    CONSTRAINT consentform1_memberid_fk FOREIGN KEY (memberid) REFERENCES mbr (memberid),
    CONSTRAINT consentform_authid_fk FOREIGN KEY (authorizedindid) REFERENCES person (personid),
    CONSTRAINT consentform_staff_fk FOREIGN KEY (staffid) REFERENCES person (personid));
    
--The code below creates the table for Payment Information where conid is the primary key and foreign key
--Check constraint for paymenttype: 'CA'= Cash, 'CK'= Check,'MO'= Money Order,'SS'= Scholarship

CREATE TABLE paymentinfo (
    conid NUMBER (6) NOT NULL,
    paymenttype CHAR (2) NOT NULL, 
    paymentamnt NUMBER (10) NOT NULL, 
    daterecievedpay DATE NOT NULL,
    dateenteredpay DATE NOT NULL,
    CONSTRAINT paymentinfo_cc CHECK (paymenttype IN ('CA', 'CK','MO','SS')),
    CONSTRAINT paymentinfo_conid_pk PRIMARY KEY (conid),
    CONSTRAINT paymentinfo2_conid_fk FOREIGN KEY (conid) REFERENCES paymentinfo (conid));  

--The code below creates the table for Social Development wheresocialdevid is the primary key and the memberid is the foreign key
--Check constraint for socialdevtype: 'DA' = Drug and Alcohol, 'LI'= Legal Issue, 'BU'= Bullying, 'FS' =Family Stress
CREATE TABLE socialdev (
    socialdevid NUMBER (6) NOT NULL,
    memberid NUMBER (6) NOT NULL,
    socialdevtype VARCHAR2 (25) NOT NULL,
    socialdevdesc VARCHAR2 (50) NOT NULL,
    CONSTRAINT socialdevtype_cc CHECK (socialdevtype IN ('DA', 'LI', 'BU', 'FS')),
    CONSTRAINT socialdev_socialdevid_pk PRIMARY KEY (socialdevid),
    CONSTRAINT socialdev_memberid_fk FOREIGN KEY (memberid) REFERENCES mbr (memberid));

--The code below creates the table for Medication where medicationid is the primary key
CREATE TABLE medication (
    medicationid NUMBER (6) NOT NULL,
    medname VARCHAR2 (50) NOT NULL,
CONSTRAINT medication_medid_pk PRIMARY KEY (medicationid));

--The code below creates the table for Health Condition where helathcondid is the primary key
--The check constraint is for the health condition name, we want to make sure whoever is entering the data spells the name right.
--We us VARCHAR2 (39) because the longest helath condition we track is 39 characters long
CREATE TABLE healthcondition (
    healthcondid NUMBER (6) NOT NULL,
    healthcondname VARCHAR2 (39) NOT NULL, 
    CONSTRAINT healthcondname_CC CHECK (healthcondname IN ('Anxiety', 'Asthma','Attention deficit hyperactive disorder',
        'Autism', 'Bi-polar', 'Bleeding disorder' , 'Bone condition','Joint condition', 'Cancer','Depression','Diabetes', 'Ear infection',
        'Eating disorder', 'Epilepsy','Seizures','Blackouts', 'Gastrointestinal disorder', 'Bowel disorder', 'Migraines', 'Headaches',
        'Hearing disability', 'Heart disease', 'Hepatitis', 'High blood pressure', 'Low blood pressure', 'Kidney disease', 'Mental problems',
        'Emotional problems')),
    CONSTRAINT healthcon_healthcondid_pk PRIMARY KEY (healthcondid));
    
--The code below creates the table for Member Health Condition where healthcondid and memberid are the primary and foreign keys.
CREATE TABLE mbr_health_condition (
  memberid NUMBER (6) NOT NULL,
  healthcondid NUMBER (6) NOT NULL,
  CONSTRAINT mbr_health_condition_pk PRIMARY KEY (healthcondid, memberid),
  CONSTRAINT mbr_health_conditionid_fk FOREIGN KEY (healthcondid) REFERENCES healthcondition (healthcondid),
  CONSTRAINT mbr_health_memberid_fk FOREIGN KEY (memberid) REFERENCES mbr (memberid));


--The code below creates the table for Medical Staff where medstaffid and memberid are the primary and foreign keys
--Check constraint for job type: 'P' = Physician, 'D' = Doctor
CREATE TABLE medstaff (
    medstaffid  NUMBER (6) NOT NULL,
    memberid    NUMBER (6) NOT NULL,
    jobtype     CHAR (1) NOT NULL,
    CONSTRAINT jobtype_cc CHECK (jobtype IN('P', 'D')),
    CONSTRAINT medstaff_medstaffid__pk PRIMARY KEY (medstaffid,memberid),
    CONSTRAINT medstaff_staffid_fk FOREIGN KEY (medstaffid) REFERENCES person (personid),
    CONSTRAINT medstaff_memberid_fk FOREIGN KEY (memberid) REFERENCES mbr (memberid));
    
    
--The code below creates the table for Member Medical Informaton where memberid, medicationid and medstaffid are the primary and foreign keys
--We use VARCHAR2 (25) for amnt_medication (amount of medication to take) so that the person can identify the units. For example take 2 pills or 3 teaspons
CREATE TABLE mbrmedinfo (
    memberid NUMBER (6) NOT NULL, 
    medicationid NUMBER (6) NOT NULL,
    medstaffid NUMBER (6) NOT NULL,
    amnt_medication VARCHAR2 (25) NOT NULL,
    how_medication VARCHAR2 (25) NOT NULL,
    time_medication VARCHAR2 (35) NOT NULL, 
    reason_medication VARCHAR (50) NOT NULL,
    CONSTRAINT mbrmedinfo_memberid_pk PRIMARY KEY (memberid,medicationid,medstaffid),
    CONSTRAINT mbrmedinfo_memberid_fk FOREIGN KEY (memberid) REFERENCES mbr (memberid),
    CONSTRAINT mbrmedinfo_medid_fk FOREIGN KEY (medicationid) REFERENCES medication (medicationid),
    CONSTRAINT mbrmedinfo_medstaffid_fk FOREIGN KEY (medstaffid) REFERENCES person (personid));
       
--Sequence is created to generate numbers for the PK personid
CREATE SEQUENCE seqpersonid
  START WITH 1
  INCREMENT BY 1
  NOCACHE;

--Intert statements for table person 
INSERT INTO person VALUES (seqpersonid.NEXTVAL, 'Johnson', 'Montrell', 'D');
INSERT INTO person VALUES (seqpersonid.NEXTVAL, 'Simonis', 'Brandon', 'D');
INSERT INTO person VALUES (seqpersonid.NEXTVAL, 'Ibe', 'Stacey', 'H');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Johnson', 'Riley');
INSERT INTO person  VALUES (seqpersonid.NEXTVAL, 'Zhang', 'Moli', 'J');
INSERT INTO person VALUES (seqpersonid.NEXTVAL, 'Simon', 'Jamie', 'J');
INSERT INTO person VALUES (seqpersonid.NEXTVAL, 'Berkley', 'Ethan', 'N');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Wentzel', 'Claire');
INSERT INTO person VALUES (seqpersonid.NEXTVAL, 'Wentzel', 'Jose', 'R');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'England', 'Ben');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Kay', 'Mary');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Strong', 'Derek');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Karp', 'David');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Ott', 'Scott');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Derks', 'Adam');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Derks', 'Moriah');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Hank', 'Aron');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Johnson', 'Aaron');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Johnson', 'Hayley');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Johnson', 'Mary');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Simonis', 'Danny');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Simonis', 'Sandy');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Simonis', 'David');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Simonis', 'Kyle');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Ibe', 'Molly');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Ibe', 'Brooke');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Ibe', 'Joe');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Johnson', 'Emily');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Johnson', 'Frank');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Zhang', 'Qian');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Zhang', 'Samuel');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Zhang', 'Chen');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Simon', 'Nick');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Van Roy', 'Kim');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Braun', 'Ryan');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Berkley', 'Tom');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Berkley', 'Sue');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Berkley', 'Tim');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Berkley', 'Shannon');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Wentzel', 'Hailey');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Wentzel', 'Mike');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Varian', 'Brooke');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Kapping', 'Mitchell');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Carter', 'Matthew');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Kelley', 'Aaron');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Wians', 'Andy');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Gust', 'Leisha');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Bauer', 'Sharon');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Lake', 'Kendal');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Gunderson', 'James');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Smith', 'Jake');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Anderson', 'Jess');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Culver', 'Kyle');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Holtz', 'Liz');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Glor', 'Grace');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Anderson', 'Nick');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Kann', 'Ryan');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'Pelton', 'Jen');
INSERT INTO person (personid, lname, fname) VALUES (seqpersonid.NEXTVAL, 'The Counter', 'Over');


--Insert statements for email
INSERT INTO email VALUES (2, 'mjohnson@gmail.com');
INSERT INTO email VALUES (3, 'bsimonis59@gmail.com');
INSERT INTO email VALUES (5, 'rjohnson@yahoo.com');
INSERT INTO email VALUES (6, 'mzhang4@yahoo.com');
INSERT INTO email VALUES (8, 'eberkley@gmail.com');
INSERT INTO email VALUES (9, 'cwentzel@gmail.com');
INSERT INTO email VALUES (10, 'josewent@yahoo.com');
INSERT INTO email VALUES (19, 'ajohnson@yahoo.com');
INSERT INTO email VALUES (20, 'hjohnson@outlook.com');
INSERT INTO email VALUES (21, 'mjohnson55@microsoft.com');
INSERT INTO email VALUES (22, 'daniel.simonis@saceredheart.org');
INSERT INTO email VALUES (23, 'sandy.simonis@gmail.com');
INSERT INTO email VALUES (24, 'dsimonis2@gmail.com');
INSERT INTO email VALUES (25, 'ksimonis69@yahoo.com');
INSERT INTO email VALUES (26, 'molly.ibe333@yahoo.com');
INSERT INTO email VALUES (27, 'brookeibe99@gmail.com');
INSERT INTO email VALUES (28, 'joe.ibe.football@gmail.com');
INSERT INTO email VALUES (29, 'ejohnson3@outlook.com');
INSERT INTO email VALUES (30, 'fjohnson@outlook.com');
INSERT INTO email VALUES (32, 'szhang89@yahoo.com');
INSERT INTO email VALUES (33, 'chenz190@yahoo.com');
INSERT INTO email VALUES (34, 'nsimon@gmail.com');
INSERT INTO email VALUES (35, 'kimban9@yahoo.com');
INSERT INTO email VALUES (36, 'rbraun@microsoft.com');
INSERT INTO email VALUES (37, 't.berk@yahoo.com');
INSERT INTO email VALUES (38, 's.berk36@gmail.com');
INSERT INTO email VALUES (39, 'tim.berkley@gmail.com');
INSERT INTO email VALUES (40, 'shannon.berkley2@gmail.com');
INSERT INTO email VALUES (43, 'bvarian3459@outlook.com');

--Insert statements for teacher
INSERT INTO teacher VALUES (2,11,'FR', TO_DATE( '2017', 'YYYY'), TO_DATE( '2018', 'YYYY'));
INSERT INTO teacher VALUES (2,15,'8', TO_DATE( '2016', 'YYYY'), TO_DATE( '2017', 'YYYY'));
INSERT INTO teacher VALUES (3,12,'5', TO_DATE( '2017', 'YYYY'), TO_DATE( '2018', 'YYYY'));
INSERT INTO teacher VALUES (3,13,'4', TO_DATE( '2016', 'YYYY'), TO_DATE( '2017', 'YYYY'));
INSERT INTO teacher VALUES (4,12,'5', TO_DATE( '2017', 'YYYY'), TO_DATE( '2018', 'YYYY'));
INSERT INTO teacher VALUES (5,11,'SO', TO_DATE( '2017', 'YYYY'), TO_DATE( '2018', 'YYYY'));
INSERT INTO teacher VALUES (6,14,'5K', TO_DATE( '2017', 'YYYY'), TO_DATE( '2018', 'YYYY'));
INSERT INTO teacher VALUES (6,16,'4K', TO_DATE( '2016', 'YYYY'), TO_DATE( '2017', 'YYYY'));
INSERT INTO teacher VALUES (7,15,'7', TO_DATE( '2017', 'YYYY'), TO_DATE( '2018', 'YYYY'));
INSERT INTO teacher VALUES (7,12,'6', TO_DATE( '2016', 'YYYY'), TO_DATE( '2017', 'YYYY'));
INSERT INTO teacher VALUES (8,17,'2', TO_DATE( '2017', 'YYYY'), TO_DATE( '2018', 'YYYY'));
INSERT INTO teacher VALUES (9,18,'3', TO_DATE( '2017', 'YYYY'), TO_DATE( '2018', 'YYYY'));
INSERT INTO teacher VALUES (10,15,'7', TO_DATE( '2017', 'YYYY'), TO_DATE( '2018', 'YYYY'));
INSERT INTO teacher VALUES (10,12,'6', TO_DATE( '2017', 'YYYY'), TO_DATE( '2018', 'YYYY'));


--Sequence is created to generate numbers for the PK addressid
CREATE SEQUENCE seqaddressid
  START WITH 1
  INCREMENT BY 1
  NOCACHE;

--Insert Statments for address
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '422 Kay Street', 'Eau Claire',DEFAULT, '54703-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '505 5th Street', 'Chippewa Falls',DEFAULT, '54729');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '800 Keith Street', 'Eau Claire',DEFAULT, '54703-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '900 Lake Sreet', 'Eau Claire',DEFAULT, '54701-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '122 4th Sreet', 'Eau Claire',DEFAULT, '54701-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '150 Stanley Street', 'Stanley',DEFAULT, '54768');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '600 Hastings', 'Eau Claire',DEFAULT, '54701-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '700 5th', 'Eau Claire',DEFAULT, '54701-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '500 Kim Street', 'Eau Claire',DEFAULT, '54703-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '200 Birch Street', 'Eau Claire',DEFAULT, '54703-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '434 North Lane', 'Eau Claire',DEFAULT, '54703-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '400 Galloway Street', 'Eau Claire',DEFAULT, '54703-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '440 North Shore Drive', 'Seymour',DEFAULT, '54702-6363');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '808 14th Street', 'Eau Claire',DEFAULT, '54701-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '1244 State Street', 'Eau Claire',DEFAULT, '54703-6362');
INSERT INTO address VALUES(seqaddressid.NEXTVAL, '422 Hudson Street', 'Eau Claire',DEFAULT, '54703-6362');



--Sequence created to generate numbers for phoneid
CREATE SEQUENCE seqphoneid
START WITH 1
INCREMENT BY 1
NOCACHE;

--Insert Statements for table phone
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7158586969, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7158500058, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 9207455845, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7156870214, 'H');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 9207405560, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 9207405562, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7159854562, 'H');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 9208431497, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 9208580058, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7158884566, 'H');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7154200001, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 9208584848, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 6128556566, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7155147185, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7155147186, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 4145158978, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7158975654, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7155148008, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7155148052, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7155996212, 'H');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7155643234, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7158974454, 'H');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 6128556969, 'C');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7152349860, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 6123959734, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7159873410, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 6128863304, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7154378921, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7157831084, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 6129932964, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7158675432, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7158354521, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7158342367, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7155670938, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 7153460984, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 6122348934, 'W');
INSERT INTO phone VALUES (seqphoneid.NEXTVAL, 6127652348, 'W');

--Insert Statements for table person_phone
INSERT INTO person_phone VALUES (2,19);
INSERT INTO person_phone VALUES (3,20);
INSERT INTO person_phone VALUES (4,21);
INSERT INTO person_phone VALUES (5,22);
INSERT INTO person_phone VALUES (5,23);
INSERT INTO person_phone VALUES (6,24);
INSERT INTO person_phone VALUES (7,25);
INSERT INTO person_phone VALUES (8,26);
INSERT INTO person_phone VALUES (9,27);
INSERT INTO person_phone VALUES (10,28);
INSERT INTO person_phone VALUES (11,29);
INSERT INTO person_phone VALUES (11,30);
INSERT INTO person_phone VALUES (12,31);
INSERT INTO person_phone VALUES (13,32);
INSERT INTO person_phone VALUES (14,33);
INSERT INTO person_phone VALUES (15,34);
INSERT INTO person_phone VALUES (16,35);
INSERT INTO person_phone VALUES (17,36);
INSERT INTO person_phone VALUES (18,37);
INSERT INTO person_phone VALUES (19,38);
INSERT INTO person_phone VALUES (20,39);
INSERT INTO person_phone VALUES (21,40);
INSERT INTO person_phone VALUES (22,41);
INSERT INTO person_phone VALUES (23,42);
INSERT INTO person_phone VALUES (24,43);
INSERT INTO person_phone VALUES (25,46);
INSERT INTO person_phone VALUES (26,47);
INSERT INTO person_phone VALUES (27,48);
INSERT INTO person_phone VALUES (28,49);
INSERT INTO person_phone VALUES (29,50);
INSERT INTO person_phone VALUES (30,51);
INSERT INTO person_phone VALUES (31,52);
INSERT INTO person_phone VALUES (32,53);
INSERT INTO person_phone VALUES (33,54);
INSERT INTO person_phone VALUES (34,55);
INSERT INTO person_phone VALUES (35,56);
INSERT INTO person_phone VALUES (36,57);
INSERT INTO person_phone VALUES (37,58);
INSERT INTO person_phone VALUES (38,59);

--Insert statements for authorized individual (AuthorizedID,MbrID,Relship,Y,Y,Y,Y,Addrid,PhoneId)
INSERT INTO authorized_individual VALUES (19,2,'M', 'Father', 'Y', 'Y', 'Y','Y',2,2);
INSERT INTO authorized_individual VALUES (20,2, 'F', 'Mother', 'N', 'Y', 'Y','Y',2,3);
INSERT INTO authorized_individual VALUES (21,2, 'F', 'Aunt', 'N', 'Y', 'Y','N',3,4);
INSERT INTO authorized_individual VALUES (22,3, 'M','Father', 'Y', 'Y', 'Y','Y',4,5);
INSERT INTO authorized_individual VALUES (23,3, 'F','Mother', 'N','Y', 'Y', 'Y',4,5);
INSERT INTO authorized_individual VALUES (24,3, 'M','Uncle', 'N', 'Y', 'N','N',5,6);
INSERT INTO authorized_individual VALUES (25,3, 'M','Brother', 'N', 'N', 'Y', 'N',4,7);
INSERT INTO authorized_individual VALUES (26,4, 'F','Mother', 'Y', 'Y', 'Y','Y',6,8);
INSERT INTO authorized_individual VALUES (27,4, 'F','Aunt', 'N', 'Y', 'Y','Y',7,9);
INSERT INTO authorized_individual VALUES (28,4, 'M','Uncle', 'N', 'Y', 'Y','N',7,10);
INSERT INTO authorized_individual VALUES (29,5, 'F','Mother', 'Y', 'Y', 'Y','Y',8,11);
INSERT INTO authorized_individual VALUES (30,5, 'M', 'Father', 'N', 'Y', 'Y','Y',8,11);
INSERT INTO authorized_individual VALUES (31,6, 'M','Father', 'Y', 'Y', 'Y','Y',9,12);
INSERT INTO authorized_individual VALUES (32,6, 'M','Uncle', 'N', 'Y', 'Y','Y',10,13);
INSERT INTO authorized_individual VALUES (33,6, 'F', 'Aunt', 'N', 'Y', 'Y','N',10,14);
INSERT INTO authorized_individual VALUES (34,7, 'M','Father', 'Y', 'Y', 'Y','Y',11,15);
INSERT INTO authorized_individual VALUES (35,7, 'M','Uncle', 'N', 'Y', 'Y','N',12,16);
INSERT INTO authorized_individual VALUES (36,7, 'M', 'Cousin', 'N', 'Y', 'N','N',13,17);
INSERT INTO authorized_individual VALUES (37,8, 'M', 'Father', 'Y', 'Y', 'Y','Y',14,18);
INSERT INTO authorized_individual VALUES (38,8, 'F','Mother', 'N', 'Y', 'Y','Y',14,19);
INSERT INTO authorized_individual VALUES (39,8, 'M','Uncle', 'N', 'Y', 'Y','N',15,20);
INSERT INTO authorized_individual VALUES (40,8, 'F','Aunt', 'N', 'Y', 'Y','N',15,21);
INSERT INTO authorized_individual VALUES (41,9, 'F','Grandmother', 'Y', 'Y', 'Y','Y',16,22);
INSERT INTO authorized_individual VALUES (42,9, 'M','Grandfather', 'N', 'Y', 'Y','Y',16,23);
INSERT INTO authorized_individual VALUES (43,9, 'F','Family Friend', 'N', 'Y', 'Y','N',17,24);
INSERT INTO authorized_individual VALUES (41,10, 'F','Grandmother', 'Y', 'Y', 'Y','Y',16,22);
INSERT INTO authorized_individual VALUES (42,10, 'M','Grandfather', 'N', 'Y', 'Y','Y',16,23);
INSERT INTO authorized_individual VALUES (43,10, 'F','Family Friend', 'N', 'N', 'Y','N',17,24);


--Sequence created to generat numbers for org_id
CREATE SEQUENCE seqord_id
START WITH 1
INCREMENT BY 1;

--Insert statements for table org
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'Menards', 7158300011);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'Festival', 715838100);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'Target', 7158380196);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'Sacred Heart Hospital', 7157174121);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'University of Wisconsin-Eau Claire', 7158364636);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'Sodexo', 7158362186);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'Golds Gym', 7155524570);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'Shopko', 7158329777);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'Memorial High School', 7158526600);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'South Middle School', 7158525200);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'LakeShore Elementary School', 7158523400);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'Manz Elementary School', 7158523900);
INSERT INTO org VALUES (seqord_id.NEXTVAL, 'Mayo Clinic Hospital', 7158324591);

--Insert statements for table person_org
INSERT INTO person_org VALUES (19, 2);
INSERT INTO person_org VALUES (26, 2);
INSERT INTO person_org VALUES (30, 2);
INSERT INTO person_org VALUES (37, 2);
INSERT INTO person_org VALUES (42, 2);
INSERT INTO person_org VALUES (41, 3);
INSERT INTO person_org VALUES (20, 3);
INSERT INTO person_org VALUES (25, 3);
INSERT INTO person_org VALUES (24, 4);
INSERT INTO person_org VALUES (21, 5);
INSERT INTO person_org VALUES (22, 5);
INSERT INTO person_org VALUES (23, 5);
INSERT INTO person_org VALUES (40, 5);
INSERT INTO person_org VALUES (43, 5);
INSERT INTO person_org VALUES (27, 6);
INSERT INTO person_org VALUES (31, 6);
INSERT INTO person_org VALUES (36, 6);
INSERT INTO person_org VALUES (39, 6);
INSERT INTO person_org VALUES (33, 6);
INSERT INTO person_org VALUES (34, 6);
INSERT INTO person_org VALUES (37, 7);
INSERT INTO person_org VALUES (35, 7);
INSERT INTO person_org VALUES (28, 8);
INSERT INTO person_org VALUES (32, 8);
INSERT INTO person_org VALUES (29, 9);
INSERT INTO person_org VALUES (11, 10);
INSERT INTO person_org VALUES (15, 11);
INSERT INTO person_org VALUES (12, 12);
INSERT INTO person_org VALUES (13, 12);
INSERT INTO person_org VALUES (14, 12);
INSERT INTO person_org VALUES (16, 12);
INSERT INTO person_org VALUES (17, 12);
INSERT INTO person_org VALUES (18, 13);
INSERT INTO person_org VALUES (46, 5);
INSERT INTO person_org VALUES (47, 5);
INSERT INTO person_org VALUES (48, 14);
INSERT INTO person_org VALUES (49, 5);
INSERT INTO person_org VALUES (50, 14);
INSERT INTO person_org VALUES (51, 5);
INSERT INTO person_org VALUES (52, 5);
INSERT INTO person_org VALUES (53, 5);
INSERT INTO person_org VALUES (54, 14);
INSERT INTO person_org VALUES (55, 5);
INSERT INTO person_org VALUES (56, 14);
INSERT INTO person_org VALUES (57, 14);
INSERT INTO person_org VALUES (58, 5);
INSERT INTO person_org VALUES (59, 14);
INSERT INTO person_org VALUES (2, 14);
INSERT INTO person_org VALUES (3 ,14);
INSERT INTO person_org VALUES (4, 5);
INSERT INTO person_org VALUES (5, 5);
INSERT INTO person_org VALUES (6, 14);
INSERT INTO person_org VALUES (7, 5);
INSERT INTO person_org VALUES (8, 5);
INSERT INTO person_org VALUES (9, 14);
INSERT INTO person_org VALUES (10, 5);


--the code below creates the sequence for Date of Birth ID. 
CREATE SEQUENCE dobirthseq
START WITH 1
INCREMENT BY 1
NOCACHE;

--The table below creates the date of birth ID 
INSERT INTO dobirth VALUES (dobirthseq.NEXTVAL, '21-OCT-04');
INSERT INTO dobirth VALUES (dobirthseq.NEXTVAL, '31-MAY-06');
INSERT INTO dobirth VALUES (dobirthseq.NEXTVAL, '04-JUL-05');
INSERT INTO dobirth VALUES (dobirthseq.NEXTVAL, '05-OCT-02'); 
INSERT INTO dobirth VALUES (dobirthseq.NEXTVAL, '04-JUL-06');
INSERT INTO dobirth VALUES (dobirthseq.NEXTVAL, '05-MAR-15');
INSERT INTO dobirth VALUES (dobirthseq.NEXTVAL, '13-MAY-10');
INSERT INTO dobirth VALUES (dobirthseq.NEXTVAL, '12-JAN-05');

--The code below are the insers statement for Homework table
INSERT INTO hw VALUES (2,'Geometry and history');
INSERT INTO hw VALUES (3,'Math and reading Harry Potter');
INSERT INTO hw VALUES (4,'Help with Science of rocks');
INSERT INTO hw VALUES (5,'Statistics and writing');
INSERT INTO hw VALUES (6,'Reading chapter books');
INSERT INTO hw VALUES (7,'Writing');
INSERT INTO hw VALUES (8,'Social Studies');
INSERT INTO hw VALUES (9,'Algebra');

--Sequence created to generate numbers for famid
CREATE SEQUENCE seqfamid
START WITH 1
INCREMENT BY 1;

--Insert statement for Familyinfo
INSERT INTO familyinfo VALUES (seqfamid.NEXTVAL, 3, 50000, 'B', 'N', DEFAULT); 
INSERT INTO familyinfo VALUES (seqfamid.NEXTVAL, 4, 27000, 'B', 'N', 'Army');
INSERT INTO familyinfo VALUES (seqfamid.NEXTVAL, 2, 35000, 'M', 'Y', DEFAULT); 
INSERT INTO familyinfo VALUES (seqfamid.NEXTVAL, 5, 55000, 'B', 'Y', DEFAULT);
INSERT INTO familyinfo VALUES (seqfamid.NEXTVAL, 3, 45000, 'F', 'Y', 'Navy'); 
INSERT INTO familyinfo VALUES (seqfamid.NEXTVAL, 2, 30000, 'R', 'Y', 'Marine'); 
INSERT INTO familyinfo VALUES (seqfamid.NEXTVAL, 5, 40000, 'B', 'Y', DEFAULT); 
INSERT INTO familyinfo VALUES (seqfamid.NEXTVAL, 6, 55000, 'GP', 'Y', 'Army'); 
 
--The table below creates the table for mbr
INSERT INTO mbr VALUES (2,'M', 2,3,2);
INSERT INTO mbr VALUES (3, 'M', 3, 3,4);
INSERT INTO mbr VALUES (4, 'F', 3, 4,6);
INSERT INTO mbr VALUES (5, 'M',4,5,8);
INSERT INTO mbr VALUES (6, 'F',5,6,9);
INSERT INTO mbr VALUES (7, 'M',6,6,11);
INSERT INTO mbr VALUES (8, 'M',7,7,14);
INSERT INTO mbr VALUES (9, 'F',8,7,16);
INSERT INTO mbr VALUES (10,'M',9,8,16);

--Sequence created to generate numbers for ethnicity
CREATE SEQUENCE seqethnicity
START WITH 1
INCREMENT BY 1;
--The code below are the insert statements for the Ethnicity Table
--Check Constraint for ethnicity 'C'= Caucasian, 'AA' = African American, 'AI' = American Indian, 'AP' = Asian-Asian Pacific,
--'HP' = Hispanic-Latino, 'ME' = Multi-Ethnic, 'O'= Other
INSERT INTO Ethnicity VALUES (seqethnicity.NEXTVAL, 'C');
INSERT INTO Ethnicity VALUES (seqethnicity.NEXTVAL, 'AA');
INSERT INTO Ethnicity VALUES (seqethnicity.NEXTVAL, 'AI');
INSERT INTO Ethnicity VALUES (seqethnicity.NEXTVAL, 'AP');
INSERT INTO Ethnicity VALUES (seqethnicity.NEXTVAL, 'HP');
INSERT INTO Ethnicity VALUES (seqethnicity.NEXTVAL, 'ME');
INSERT INTO Ethnicity VALUES (seqethnicity.NEXTVAL, 'O');


--The code below are the insert statements for the Member_Ethnicity table
INSERT INTO Member_Ethnicity VALUES (2,2);
INSERT INTO Member_Ethnicity VALUES (3,3);
INSERT INTO Member_Ethnicity VALUES (4,5);
INSERT INTO Member_Ethnicity VALUES (5,8);
INSERT INTO Member_Ethnicity VALUES (6,4);
INSERT INTO Member_Ethnicity VALUES (7,6);
INSERT INTO Member_Ethnicity VALUES (8,7);
INSERT INTO Member_Ethnicity VALUES (9,6);
INSERT INTO Member_Ethnicity VALUES (10,2);

--The code below are the insert statement for Truancy Table
INSERT INTO truancy VALUES (3,'Fighting with students');
INSERT INTO truancy VALUES (5,'Skipping class');
INSERT INTO truancy VALUES (9,'Bullying');

--the code below creates the sequence for Academic Information. 
CREATE SEQUENCE academicinformationseq
START WITH 1
INCREMENT BY 1
NOCACHE;

--The code below are the insert statements for Academic Information
INSERT INTO academic_info VALUES (academicinformationseq.NEXTVAL,2,'Does well in classes, gets As and Bs','Y','N','FR');
INSERT INTO academic_info VALUES (academicinformationseq.NEXTVAL,3,'Grades are bad,Failing most classes','N','N','5');
INSERT INTO academic_info VALUES (academicinformationseq.NEXTVAL,4,'A,B,C grades, not failing','Y','N','5');
INSERT INTO academic_info VALUES (academicinformationseq.NEXTVAL,5,'Very bad, needs help with all classes','Y','N','SO');
INSERT INTO academic_info VALUES (academicinformationseq.NEXTVAL,6,'Great! All As','Y','N','5K');
INSERT INTO academic_info VALUES (academicinformationseq.NEXTVAL,7,'Phenonemal  Student, All As','Y','N','7');
INSERT INTO academic_info VALUES (academicinformationseq.NEXTVAL,8,'Needs help with reading','Y','N','2');
INSERT INTO academic_info VALUES (academicinformationseq.NEXTVAL,9,'Practice Speech','N','Y','3');
INSERT INTO academic_info VALUES (academicinformationseq.NEXTVAL,10,'Needs assistance with Math and Science','N','N','5');

--The code below creates the sequence for attendance. 
CREATE SEQUENCE attendanceseq
START WITH 1
INCREMENT BY 1
NOCACHE;

--This table creates the attendance for members.
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:00', 'HH24:MI'), TO_DATE('18:30', 'HH24:MI'), '1-MAR-2018', 6);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('14:30', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), '1-MAR-2018', 8);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:00', 'HH24:MI'), TO_DATE('17:00', 'HH24:MI'), '2-MAR-2018', 2);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:00', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), '2-MAR-2018', 3);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:00', 'HH24:MI'), TO_DATE('17:00', 'HH24:MI'), '2-MAR-2018', 4);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:00', 'HH24:MI'), TO_DATE('18:30', 'HH24:MI'), '2-MAR-2018', 6);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('14:30', 'HH24:MI'), TO_DATE('17:00', 'HH24:MI'), '2-MAR-2018', 7);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('14:30', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), '2-MAR-2018', 8);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:00', 'HH24:MI'), TO_DATE('17:30', 'HH24:MI'), '2-MAR-2018', 9);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:00', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), '2-MAR-2018', 10);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:00', 'HH24:MI'), TO_DATE('17:00', 'HH24:MI'), '5-MAR-2018', 2);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('13:30', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), '5-MAR-2018', 3);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:00', 'HH24:MI'), TO_DATE('17:00', 'HH24:MI'), '5-MAR-2018', 4);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:30', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), '6-MAR-2018', 5);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('14:30', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), '6-MAR-2018', 8);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:00', 'HH24:MI'), TO_DATE('17:30', 'HH24:MI'), '6-MAR-2018', 9);
INSERT INTO attendance VALUES (attendanceseq.NEXTVAL, TO_DATE('15:30', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), '6-MAR-2018', 10);


--Sequence is created to generate numbers for the PK conid
CREATE SEQUENCE seqconid
START WITH 1
INCREMENT BY 1
NOCACHE;

--Insert values into the consent form table
INSERT INTO consentform VALUES (seqconid.NEXTVAL, 'R', '05-JAN-2018', '15-JAN-2018', TO_DATE('15:30', 'HH24:MI'), 'Y', 4, 26, 44);
INSERT INTO consentform VALUES (seqconid.NEXTVAL, 'R', '15-FEB-2018', '20-FEB-2018', TO_DATE('15:30', 'HH24:MI'), 'Y', 3, 22, 45);
INSERT INTO consentform VALUES (seqconid.NEXTVAL, 'N', '05-DEC-2017', '08-DEC-2017', TO_DATE('15:30', 'HH24:MI'), 'Y', 2, 19, 44);
INSERT INTO consentform VALUES (seqconid.NEXTVAL, 'R', '10-JAN-2018', '13-JAN-2018', TO_DATE('15:30', 'HH24:MI'), 'Y', 5, 29, 44);
INSERT INTO consentform VALUES (seqconid.NEXTVAL, 'G', '20-FEB-2018', '23-MAY-2018', TO_DATE('15:30', 'HH24:MI'), 'N', 7, 34, 45);
INSERT INTO consentform VALUES (seqconid.NEXTVAL, 'R', '10-OCT-2017', '18-OCT-2017', TO_DATE('14:30', 'HH24:MI'), 'Y', 6, 31, 45);
INSERT INTO consentform VALUES (seqconid.NEXTVAL, 'R', '26-JAN-2018', '15-SEP-2018', TO_DATE('16:00', 'HH24:MI'), 'N', 8, 37, 45);
INSERT INTO consentform VALUES (seqconid.NEXTVAL, 'N', '15-SEP-2017', '20-SEP-2017', TO_DATE('15:30', 'HH24:MI'), 'Y', 9, 41, 44);
INSERT INTO consentform VALUES (seqconid.NEXTVAL, 'N', '15-SEP-2017', '20-SEP-2017', TO_DATE('15:30', 'HH24:MI'), 'Y', 10, 41, 44);

--Insert values into the paymentinfo table
INSERT INTO paymentinfo VALUES (2, 'CA', '15', '05-JAN-2018', '06-JAN-2018');
INSERT INTO paymentinfo VALUES (3, 'CK', '15', '15-FEB-2018', '20-FEB-2018');
INSERT INTO paymentinfo VALUES (4, 'MO', '50', '05-DEC-2017', '08-DEC-2017');
INSERT INTO paymentinfo VALUES (5, 'SS', '15', '10-JAN-2017', '15-JAN-2017');
INSERT INTO paymentinfo VALUES (7, 'SS', '15', '10-OCT-2017', '11-OCT-2017');
INSERT INTO paymentinfo VALUES (8, 'CA', '15', '26-JAN-2018', '26-JAN-2018');
INSERT INTO paymentinfo VALUES (9, 'CK', '30', '15-SEP-2017', '30-SEP-2017');
INSERT INTO paymentinfo VALUES (10, 'CK', '30', '25-SEP-2017', '30-SEP-2017');

--The code below creates the sequence for the social development ID
CREATE SEQUENCE socialdevseq
START WITH 1
INCREMENT BY 1
NOCACHE;

--The code below are the insert statements for the Social Devlopment Table
--Check constraint for socialdevtype: 
--'DA' = Drug and Alcohol, 'LI'= Legal Issue, 'BU'= Bullying, 'FS' =Family Stress
INSERT INTO socialdev VALUES (socialdevseq.NEXTVAL,3,'LI','Fighting with students');
INSERT INTO socialdev VALUES (socialdevseq.NEXTVAL,5,'FS','Parents getting divorced');
INSERT INTO socialdev VALUES (socialdevseq.NEXTVAL,9,'LI','Bullies other students');

--The code below creates the sequence for school services.
CREATE SEQUENCE sevicesseq
START WITH 1
INCREMENT BY 1
NOCACHE;

--The table below creates the types of services offered.
INSERT INTO services VALUES (sevicesseq.NEXTVAL,'Speech');
INSERT INTO services VALUES (sevicesseq.NEXTVAL, 'English Language Learner');
INSERT INTO services VALUES (sevicesseq.NEXTVAL, 'Title I');
INSERT INTO services VALUES (sevicesseq.NEXTVAL, 'Cognitive Disability');
INSERT INTO services VALUES (sevicesseq.NEXTVAL, 'Learning Disability');
INSERT INTO services VALUES (sevicesseq.NEXTVAL, 'Emotional/behavioral Disability');
INSERT INTO services VALUES (sevicesseq.NEXTVAL, 'Advanced Learning Services');

--The table below creates the services provided by schools.
INSERT INTO services_provided VALUES (10, 2);
INSERT INTO services_provided VALUES (10, 3);
INSERT INTO services_provided VALUES (10, 6);
INSERT INTO services_provided VALUES (10, 7);
INSERT INTO services_provided VALUES (11, 2);
INSERT INTO services_provided VALUES (11, 3);
INSERT INTO services_provided VALUES (11, 4);
INSERT INTO services_provided VALUES (11, 5);
INSERT INTO services_provided VALUES (11, 6);
INSERT INTO services_provided VALUES (11, 7);
INSERT INTO services_provided VALUES (12, 2);
INSERT INTO services_provided VALUES (12, 3);
INSERT INTO services_provided VALUES (12, 4);
INSERT INTO services_provided VALUES (12, 5);
INSERT INTO services_provided VALUES (12, 6);
INSERT INTO services_provided VALUES (12, 7);
INSERT INTO services_provided VALUES (13, 2);
INSERT INTO services_provided VALUES (13, 3);
INSERT INTO services_provided VALUES (13, 6);
INSERT INTO services_provided VALUES (13, 7);
INSERT INTO services_provided VALUES (13, 8);


--The table below creates the services used by each member.
INSERT INTO services_used VALUES (2, 2);
INSERT INTO services_used VALUES (2, 3);
INSERT INTO services_used VALUES (5, 5);
INSERT INTO services_used VALUES (6, 6);
INSERT INTO services_used VALUES (6, 7);
INSERT INTO services_used VALUES (9, 6);


--The table below creates allergry descriptions that members provide.
INSERT INTO allergy VALUES (2, 'tree nuts, peanuts');
INSERT INTO allergy VALUES (5, 'peanuts');
INSERT INTO allergy VALUES (9, 'pollen');

--the code below creates the sequence for Medication ID. 
CREATE SEQUENCE seqmedicationid
START WITH 1
INCREMENT BY 1
NOCACHE;

--The table below creates the medication ID
INSERT INTO medication VALUES (seqmedicationid.NEXTVAL, 'Sumatriptan');
INSERT INTO medication VALUES (seqmedicationid.NEXTVAL, 'Clonazepam');
INSERT INTO medication VALUES (seqmedicationid.NEXTVAL, 'Adderall');
INSERT INTO medication VALUES (seqmedicationid.NEXTVAL, 'Zoloft');
INSERT INTO medication VALUES (seqmedicationid.NEXTVAL, 'Ziprasidone');
INSERT INTO medication VALUES (seqmedicationid.NEXTVAL, 'Celexa');
INSERT INTO medication VALUES (seqmedicationid.NEXTVAL, 'Dr. Kings Natural Medicine Anxiety And Nervousness');

--the code below creates the sequence for Medication ID. 
CREATE SEQUENCE seqhealthcondid
START WITH 1
INCREMENT BY 1
NOCACHE;

--The code below inserts the value statements for Health Condiiton
INSERT INTO healthcondition VALUES (seqhealthcondid.NEXTVAL, 'Anxiety');
INSERT INTO healthcondition VALUES (seqhealthcondid.NEXTVAL, 'Attention deficit hyperactive disorder');
INSERT INTO healthcondition VALUES (seqhealthcondid.NEXTVAL, 'Bi-polar');
INSERT INTO healthcondition VALUES (seqhealthcondid.NEXTVAL, 'Depression');
INSERT INTO healthcondition VALUES (seqhealthcondid.NEXTVAL, 'Migraines');
INSERT INTO healthcondition VALUES (seqhealthcondid.NEXTVAL, 'Headaches');
INSERT INTO healthcondition VALUES (seqhealthcondid.NEXTVAL, 'Emotional problems');

--The code below inserts the value statements for Health Condiiton
INSERT INTO mbr_health_condition VALUES (3, 6);
INSERT INTO mbr_health_condition VALUES (4, 7);
INSERT INTO mbr_health_condition VALUES (4, 2);
INSERT INTO mbr_health_condition VALUES (5, 4);
INSERT INTO mbr_health_condition VALUES (6, 6);
INSERT INTO mbr_health_condition VALUES (7, 8);
INSERT INTO mbr_health_condition VALUES (7, 5);
INSERT INTO mbr_health_condition VALUES (7, 4);
INSERT INTO mbr_health_condition VALUES (8, 3);


--The code below inserts the value statements for member medical history.
INSERT INTO medical_history VALUES (2, '11-NOV-2017', 'Y', 'N');
INSERT INTO medical_history VALUES (3, '19-AUG-2017', 'Y', 'Y');
INSERT INTO medical_history VALUES (4, '08-JUL-2017', 'N', 'N');
INSERT INTO medical_history VALUES (5, '07-JAN-2018', 'Y', 'Y');
INSERT INTO medical_history VALUES (6, '24-MAY-2017', 'Y', 'N');
INSERT INTO medical_history VALUES (7, '29-SEP-2017', 'Y', 'N');
INSERT INTO medical_history VALUES (8, '01-NOV-2017', 'Y', 'Y');
INSERT INTO medical_history VALUES (9, '25-JAN-2017', 'Y', 'N');
INSERT INTO medical_history VALUES (10, '14-APR-2017', 'Y', 'N');

--The code below inserts the value statements for Medical Staff
INSERT INTO MEDSTAFF VALUES (46,2,'P');
INSERT INTO MEDSTAFF VALUES (47,3,'P');
INSERT INTO MEDSTAFF VALUES (48,4,'P');
INSERT INTO MEDSTAFF VALUES (49,5,'P');
INSERT INTO MEDSTAFF VALUES (50,6,'P');
INSERT INTO MEDSTAFF VALUES (51,7,'P');
INSERT INTO MEDSTAFF VALUES (52,8,'P');
INSERT INTO MEDSTAFF VALUES (53,9,'P');
INSERT INTO MEDSTAFF VALUES (53,10,'P');
INSERT INTO MEDSTAFF VALUES (54,2,'D');
INSERT INTO MEDSTAFF VALUES (55,4,'D');
INSERT INTO MEDSTAFF VALUES (56,6,'D');
INSERT INTO MEDSTAFF VALUES (57,9,'D');
INSERT INTO MEDSTAFF VALUES (58,8,'D');
INSERT INTO MEDSTAFF VALUES (59,7,'D');

--The code below creates the sequence for member release form id. 
CREATE SEQUENCE mbrrlsfrm_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

--This table creates the member realse form.
INSERT INTO memberreleaseform VALUES (mbrrlsfrm_seq.NEXTVAL, 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'A', 'Y', '18-AUG-2017', '18-AUG-2017', 2, 19);
INSERT INTO memberreleaseform VALUES (mbrrlsfrm_seq.NEXTVAL, 'Y', 'N', 'Y', 'Y', 'Y', 'Y', 'U', DEFAULT, '22-AUG-2017', '22-AUG-2017', 3, 22);
INSERT INTO memberreleaseform VALUES (mbrrlsfrm_seq.NEXTVAL, 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'U', DEFAULT, '01-SEP-2017', '01-SEP-2017', 4, 26);
INSERT INTO memberreleaseform VALUES (mbrrlsfrm_seq.NEXTVAL, 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'A', 'Y', '13-SEP-2017', '13-SEP-2017', 5, 29);
INSERT INTO memberreleaseform VALUES (mbrrlsfrm_seq.NEXTVAL, 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'U', DEFAULT, '28-AUG-2017', '28-AUG-2017', 6, 31);
INSERT INTO memberreleaseform VALUES (mbrrlsfrm_seq.NEXTVAL, 'Y', 'Y', 'N', 'Y', 'Y', 'Y', 'U', 'Y', '18-AUG-2017', '18-AUG-2017', 7, 34);
INSERT INTO memberreleaseform VALUES (mbrrlsfrm_seq.NEXTVAL, 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'U', DEFAULT, '15-SEP-2017', '15-SEP-2017', 8, 38);
INSERT INTO memberreleaseform VALUES (mbrrlsfrm_seq.NEXTVAL, 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'U', DEFAULT, '04-AUG-2017', '04-AUG-2017', 9, 41);
INSERT INTO memberreleaseform VALUES (mbrrlsfrm_seq.NEXTVAL, 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'U', DEFAULT, '04-AUG-2017', '04-AUG-2017', 10, 41);

--The code below inserts the values into the Member Medical Info Table
INSERT INTO mbrmedinfo VALUES (3,2,54,'2 Pills','Mouth','As Needed','Helps with Severe Migraines');
INSERT INTO mbrmedinfo VALUES (4,8,60,'2 Fluid Ounces','Mouth','4:30PM','For anxiety');
INSERT INTO mbrmedinfo VALUES (5,6,55,'1 Pill','Mouth','3:30 PM','For bipolar disease');
INSERT INTO mbrmedinfo VALUES (6,2,54,'1 Pill','Mouth','As Needed','For mild migraines');
INSERT INTO mbrmedinfo VALUES (7,7,57,'1 Pills','Mouth','Upon arrival','For depression');
INSERT INTO mbrmedinfo VALUES (7,5,57,'2 Pills','Mouth','5:30 PM','For emotional problems/social anexity');
INSERT INTO mbrmedinfo VALUES (7,6,58,'1 Pills','Mouth','5:30 PM','For Bipolar problems');
INSERT INTO mbrmedinfo VALUES (8,3,59,'1 Pills','Mouth','4:00 PM','For anxiety');
INSERT INTO mbrmedinfo VALUES (8,4,56,'1 Pill','Mouth','3:30 PM if not taken before arrival','Keeps attention');


 --SETS PAGE SIZE TO 5000 AND SETS LINE SIZE TO 1000
 SET pagesize 5000;
 SET linesize 1000;

--Select all queries for each table in the database
SELECT * FROM academic_info;
SELECT * FROM address;
SELECT * FROM allergy;
SELECT * FROM attendance;
SELECT * FROM authorized_individual;
SELECT * FROM consentform;
SELECT * FROM dobirth;
SELECT * FROM email;
SELECT * FROM familyinfo;
SELECT * FROM healthcondition;
SELECT * FROM mbr_health_condition;
SELECT * FROM hw;
SELECT * FROM mbr;
SELECT * FROM mbrmedinfo;
SELECT * FROM medical_history;
SELECT * FROM medication;
SELECT * FROM medstaff;
SELECT * FROM memberreleaseform;
SELECT * FROM ethnicity;
SELECT * FROM member_ethnicity;
SELECT * FROM org;
SELECT * FROM paymentinfo;
SELECT * FROM person;
SELECT * FROM person_org;
SELECT * FROM phone;
SELECT * FROM PERSON_PHONE;
SELECT * FROM services;
SELECT * FROM services_provided;
SELECT * FROM services_used;
SELECT * FROM socialdev;
SELECT * FROM teacher;
SELECT * FROM truancy;


--Business Rule #1 - Person:Member
--A person may be a member.
--Each member is a person.
--Please provide me with the first name and last names of our members at the B&G Club of Chippewa Valley.
SELECT fname AS "First Name",lname AS "Last Name" FROM person,mbr 
WHERE person.personid = mbr.memberid
ORDER BY lname, fname;

--Business Rule #2 - Authorized Individual:Address
--An authorized individual provides one address.
--Each address may belong to one or more authorized individuals.
--I need to send out the year schedule with activities to all the authorized individuals, please provide me with their names and address.
SELECT fname AS "First Name",lname AS "Last Name" ,strt AS "Street",city AS "City" ,ste AS "State",zipcode AS "Zipcode"
FROM person,authorized_individual,address
WHERE person.personid = authorized_individual.authorizedindid
AND address.addrid = authorized_individual.authaddrid
ORDER BY lname, fname;

--Business Rule #3 - Member:Address
--A member provides one address.
--Each address may belong to one or more members.
--Our members receive news letters on what is happening in the club for the month, please provide me with their name and what their address.
SELECT fname AS "First Name",lname AS "Last Name" ,strt AS "Street",city AS "City" ,ste AS "State",zipcode AS "Zipcode" 
FROM person,mbr,address
WHERE person.personid = mbr.memberid
AND address.addrid = mbr.mbraddrid
ORDER BY lname, fname;

--Business Rule #4 - Person:Person (Teacher)
--A person may be a teacher.
--A teacher is a person.
--Please provide me a list of all the teachers. 
SELECT DISTINCT (teacherid), fname AS "First Name",lname AS "Last Name" FROM person, teacher
WHERE person.personid = teacher.teacherid
ORDER BY lname, fname;

--Business Rule #5 - Person:Email 
--A person may provide one email address. 
--Each email address belongs to one person. 
--I would like to email out our event flyer. Please provide me with the names and email addresses of everyone on file.
SELECT fname AS "First Name", lname AS "Last Name", email_add AS "Email Address" FROM person INNER JOIN email USING (personid)
ORDER BY lname, fname;

--Business Rule #6 - Person:Person (Authorized Individual)
--A person may be an authorized individual for one or more people.
--Each person may provide one or more authorized individuals.
--Provide me with a list of all members and their authorized individuals who are the "head of the house".
SELECT aut.fname AS "Authorized Ind's First Name", aut.lname AS "Authorized Ind's Last Name",
per.fname AS "Person's First Name",
per.lname AS "Person's Last Name"
FROM person aut, person per, AUTHORIZED_INDIVIDUAL
WHERE aut.personid = AUTHORIZED_INDIVIDUAL.AUTHORIZEDINDID
AND per.personid = AUTHORIZED_INDIVIDUAL.memberid
AND headofhouse = 'Y'
AND aut.personid IN (SELECT (AUTHORIZEDINDID) FROM AUTHORIZED_INDIVIDUAL
GROUP BY AUTHORIZEDINDID)
ORDER BY aut.lname, aut.fname;


--Business Rule #7 - Person:Phone 
--A person may provide one phone number.
--A phone number references one or more people.
--Please provide me with the names of the people in our database who we collect phone numbers  of. 
--Order by last name,please. 
SELECT fname,lname,TO_CHAR(pnumber, '999g999g9999','nls_numeric_characters=.-')
FROM phone,person,person_phone
WHERE person.personid = person_phone.personid
AND person_phone.phoneid = phone.phoneid
ORDER BY lname,fname; 

--Business Rule #8 - Person:Consent Form 
--A person may sign one or more consent forms. 
--Each consent form is signed by one person. 
--A staff member enters in one or more consent forms. 
--Each consent form is entered by one staff member. 
--Provide me with the name of the authorized individuals that have signed a consent form.
SELECT DISTINCT (personid), fname AS "First Name", lname AS "Last Name" FROM person, authorized_individual, consentform
WHERE person.PERSONID = authorized_individual.AUTHORIZEDINDID
AND authorized_individual.AUTHORIZEDINDID = consentform.AUTHORIZEDINDID
ORDER BY lname, fname;


--Business Rule #9 - Member:Consent Form 
--A member provides one consent form. 
--Each consent form is provided by one member.
--Provide me a list of the names of our members and their current status at the club.
SELECT fname AS "First Name", lname AS "Last Name", memberstatus AS "S"
FROM person, mbr, consentform
WHERE person.personid = mbr.memberid
AND mbr.memberid = conid
ORDER BY lname, fname; 
 
--Business Rule #10 - Person:Member Release 
--A person may fill out one or more member release forms. 
--Each member release form is filled out by one person. 
--Provide me with the members name and the date that their authorized individual
--signed their member release form.
SELECT DISTINCT(personid), fname AS "First Name", lname AS "Last Name", authorizedinddatesigned AS "Date Signed" 
FROM person, memberreleaseform, authorized_individual
WHERE person.personid = memberreleaseform.release_form_id
AND memberreleaseform.authorizedindid = authorized_individual.authorizedindid
ORDER BY lname, fname;

--Business Rule #11 - Member:Member Release 
--A member provides one member release form. 
--Each member release form  belongs to one member. 
--Provide me with the names of the members that have permission to access computers.
SELECT fname AS "First Name", lname AS "Last Name", computer_access
FROM person, mbr, memberreleaseform
WHERE person.personid = mbr.memberid
AND mbr.memberid = memberreleaseform.release_form_id
AND computer_access = 'Y'
ORDER BY lname, fname; 

--Business Rule #12 - Consent Form:Payment Information
--Consent Form:Payment Information
--A consent form may need payment information.
--Each payment information belongs to one consent form.
--Provide me with all the consent forms that do not have payment information, please provide the consent formid, the members name, the authorized
--Individuals name and the authorized individuals phone number so we can contact them for payment.

SELECT consentform.conid AS "Form ID",mem.fname AS "Member First Name", mem.lname AS " Member Last Name", mem.mname AS "Member Middle Initial",
  au.fname AS "Authorized Ind. First Name", au.lname AS "Authorized Ind. Last Name",TO_CHAR(pnumber, '999g999g9999','nls_numeric_characters=.-') 
  AS "Auth. Phone #" 
  FROM consentform, mbr, person mem, person au, authorized_individual, person_phone, phone
  WHERE consentform.memberid = mbr.memberid AND mbr.memberid = mem.personid
  AND consentform.authorizedindid = authorized_individual.authorizedindid 
  AND authorized_individual.authorizedindid = au.personid
  AND au.personid = person_phone.personid
  AND person_phone.phoneid = phone.phoneid
  AND consentform.conid NOT IN (Select conid from paymentinfo
  Group by conid)
  ORDER BY conid;
  
 --Provide me with all the consent forms that have payment information please provide me with the consent form id, member names and the payment information.
 --The "T" stands for payment type
SELECT consentform.conid AS "Form ID", fname AS "Member First Name", lname AS " Member Last Name", mname AS "Member Middle Initial", paymenttype AS "T",TO_CHAR (paymentamnt, '$999,999') AS "Amount", 
  TO_CHAR(daterecievedpay, 'MM/DD/YYYY') AS "Date Rec.", TO_CHAR (dateenteredpay, 'MM/DD/YYYY') AS "Date Enter" from consentform, paymentinfo, mbr, person
  WHERE consentform.conid = paymentinfo.conid
  AND consentform.memberid = mbr.memberid
  AND mbr.memberid = person.personid
  AND consentform.conid IN (Select conid from paymentinfo
  GROUP BY conid)
  ORDER BY consentform.conid;

--Business Rule #13 - Person:Organization 
--A person may be a part of one or more organizations. 
--Each organization contains one or more people. 
 --Who works at Menards?
SELECT fname AS "First Name", lname AS "Last Name" FROM person, person_org, org
WHERE person.personid = person_org.personid
AND person_org.org_id = org.org_id
AND org_name = 'Menards'
ORDER BY lname, fname;

--Business Rule #14 - Organization:Services 
--An organization may provide one or more services. 
--Each service is provided by one or more organizations. 
--Which schools offer speech?
SELECT org_name AS "School Name" FROM org, services, services_provided
WHERE servicename = 'Speech'
AND services.servicesid = services_provided.servicesid
AND org.org_id = services_provided.schoolid
ORDER BY org_name;
 
--Business Rule #15 - Member:Services 
--A member may use one or more services. 
--Each service may be used by one or more member. 
 --Which of our members are in the learning disability service at their school?
SELECT fname AS "First Name", mname as "Middle", lname AS "Last Name" FROM person, mbr, services_used, services
WHERE servicename = 'Learning Disability'
AND person.personid = mbr.memberid
AND services_used.servicesid = services.servicesid
AND services_used.memberid = mbr.memberid
ORDER BY lname, fname;

--Business Rule #16 - Member:Date of Birth 
--A member provides one date of birth. 
--Each date of birth belongs to one or more members. 
--We want to start celebrating birthdays each month for our members, get me a list of our members and their birth dates.
SELECT fname AS "First Name", mname as "Middle", lname AS "Last Name", dob AS "Birthday" FROM person, mbr, dobirth
WHERE person.personid = mbr.memberid
AND mbr.birthid = dobirth.birthid
ORDER BY lname, fname;
 
--Business Rule #17 - Member:Other Ethnicity
--A member provides one or more ethnicities.
--Each ethnicity is provided by  one or more members.
--How many members identify as not being caucasian 
SELECT COUNT(DISTINCT(memberid)) AS "# of Members Not Caucasian" FROM mbr INNER JOIN member_ethnicity USING (memberid) 
INNER JOIN ethnicity USING (ethnicityid)
WHERE ethnicity_type <> 'C';
 
--Business Rule #18 - Member:Family Information 
--A member provides their family information. 
--Each family information belongs to one or more members. 
--How big is Ethan Berkley family? 
SELECT famsize FROM person, mbr, familyinfo
WHERE person.personid = mbr.memberid
AND mbr.famid = familyinfo.famid
AND fname = 'Ethan'
AND lname = 'Berkley'
ORDER BY lname, fname;

--Business Rule #19 - Member:Attendance
--A member may attend our club one or more times.
--Each attendance time belongs to one member.
--Provide me with the check in/check out time and the date for Montrell Johnson
SELECT fname AS "First Name", mname as "Middle", lname AS "Last Name", TO_CHAR(check_in, 'HH:MI AM') AS "Chk In", TO_CHAR(check_out, 'HH:MI AM') AS "Chk Out", ch_in_out_day AS "Date" FROM person,mbr,attendance
WHERE attendance.memberid = mbr.memberid
AND person.personid = mbr.memberid
AND fname = 'Montrell'
AND lname = 'Johnson'
ORDER BY lname, fname;
--Business Rule #20 - Member:Academic Information
--A member provides academic information.
--Academic information belongs to one member.
--I want to know the acedemic information from my members attending B&G Club
SELECT GRADE AS "Grade", LNAME AS "Last Name", FNAME AS "First Name" FROM PERSON, MBR, ACADEMIC_INFO
WHERE person.personid = mbr.memberid
AND academic_info.memberid = mbr.memberid
ORDER BY lname, fname;

--Business Rule #21 - Member:Homework
--A member may be assigned homework.
--Homework is assigned to one member.
--I want to see what homework has been assigned to our members
SELECT HW_DESC AS "Homework", LNAME AS "Last Name", FNAME AS "First Name" FROM HW, MBR, PERSON
WHERE person.personid = mbr.memberid
AND HW.HW_ID = MBR.MEMBERID
ORDER BY lname, fname;

--Business Rule #22 - Member:Allergy
--A member may provide an allergy description.
--Each allergy description is provided by one member.
--Give me a list of members who have allergies and provide me with those allergies
SELECT fname AS "First Name", lname AS "Last Name", all_desc AS "Allergy Description" FROM person,mbr,allergy
WHERE person.personid = mbr.memberid
AND allergy.memberid = mbr.memberid
ORDER BY lname, fname;

--Business Rule #23 - Member:Social Development
--A member may report one or more social development issues.
--Each social development issue is reported by one member.
--Give me a list of members with Social Development issues
SELECT fname AS "First Name", lname AS "Last Name", socialdevdesc AS "Social Development Issue" FROM person, mbr, socialdev
WHERE person.personid = mbr.memberid
AND socialdev.socialdevid = mbr.memberid
ORDER BY lname, fname;

--Business Rule #24 - Member:Truancy
--A member may be involved in truancy issues.
--Each truancy issue is associated with one member.
--Give me a list members with Truancy and their issue descriptions 
SELECT fname AS "First Name", lname AS "Last Name", truancy_desc AS "Truancy Description" FROM person, mbr, truancy
WHERE person.personid = mbr.memberid
AND truancy.memberid = mbr.memberid
ORDER BY lname, fname;

--Business Rule #25 - Member:Medical history:
--A member provides their medical history. 
--Each medical history is provided by one member. 
--Which members are receiving counseling? Provide their first, middle(if they have one) and last name
SELECT fname AS "First Name", mname as "Middle Initial", lname as "Last Name" FROM person, mbr, medical_history
WHERE person.personid = mbr.memberid AND
mbr.memberid = medical_history.memberid 
AND rec_counseling =  'Y' 
ORDER BY lname, fname;

--Business Rule #26 - Person:Person (Doctor/Physician) 
--A person may provide one or more medical staff people(doctor or physician).
--Each medical staff person is provided by one person.
--Which physician(s) were provided by two or more members? Please provide the physcians first and last name of the physician(s) and the name of the members
-- who provided the physician.
-- Which members have the same physician please provide me with the member's first, middle, and last name, and the physician's first and last name

SELECT med.fname AS "Physician's First Name", med.lname AS "Physician's Last Name", mem.fname AS "Member's First Name",
mem.mname AS "Member's Middle Name", mem.lname AS "Member's Last Name" FROM person med, person mem, medstaff
WHERE med.personid = medstaff.MEDSTAFFID
AND mem.personid = medstaff.memberid
AND jobtype = 'P'
and med.personid IN (SELECT (medstaffid) FROM medstaff
GROUP BY medstaffid
HAVING COUNT (memberid) >=2) 
ORDER BY mem.lname, mem.fname;

--Business Rule #27-Member:Medication:Medical Staff 
--A member can take one or more medications that are prescribed by a doctor.
--Each medication is prescribed by one doctor and taken by one or more members.
--Each doctor prescribes one or more medications to be taken by one or more members.
--Please provide me with all members who take more than one medication. What medicationsdo they take at what time and which doctors perscribe them.
SELECT mem.fname AS "Member First Name", mem.lname AS "Last Name", medname AS "Medication Name", time_medication AS "Time to Take", 
  doc.fname AS "Doctor Frist Name", doc.lname AS "Doctor Last Name" 
  FROM person mem, person doc, mbr, mbrmedinfo, medication, medstaff
  WHERE mbr.memberid = mbrmedinfo.memberid AND mbrmedinfo.medicationid = medication.medicationid
  AND mbrmedinfo.medstaffid = medstaff.medstaffid 
  AND mbr.memberid = mem.personid
  AND medstaff.medstaffid= doc.personid
  AND mbrmedinfo.memberid IN (SELECT memberid FROM mbrmedinfo
  GROUP BY memberid HAVING COUNT(medicationid) >1)
  ORDER BY mem.lname, mem.fname;

--Business Rule #28 Member:Health Condition
--A member may provide one or more helath conditions.
--Each health condition is provided by one or more members. 
SELECT healthcondname AS "Health Condition", fname AS "First Name", lname AS "Last Name" FROM person, mbr, mbr_health_condition, healthcondition
  WHERE person.personid = mbr.memberid AND mbr.memberid = mbr_health_condition.memberid
  AND mbr_health_condition.healthcondid = healthcondition.healthcondid AND
  mbr_health_condition.healthcondid IN (SELECT healthcondid FROM mbr_health_condition
  GROUP BY healthcondid Having COUNT(healthcondid)>=2)
  ORDER BY healthcondname;



--The queries below fufill the SQL Command requirements for the Group Project. 
--Each Managerial Request is followed by a query fuffiliing the request. 

--How many members qualify for free lunch?
--SQL Commands: COUNT, WHERE, AND, ORDER BY
SELECT COUNT(free_lunch) AS "Qualify for Free Lunch" FROM person, mbr, familyinfo 
WHERE person.personid = mbr.memberid
AND mbr.memberid = familyinfo.famid
AND free_lunch = 'Y'
ORDER BY lname, fname;


--Which members got scholarships and qualify for free lunch?
--SQL Commands: WHERE, AND, ORDER BY
SELECT fname AS "First Name", lname AS "Last Name", paymenttype, free_lunch FROM person, mbr, paymentinfo, familyinfo
WHERE person.personid = mbr.memberid
AND mbr.memberid = paymentinfo.conid
AND paymentinfo.conid = familyinfo.famid
AND paymenttype = 'SS'
AND free_lunch = 'Y'
ORDER BY lname, fname;


--Which members have an allergy?
--SQL Commands: WHERE, AND, ORDER BY
SELECT fname AS "First Name", lname AS "Last Name", all_desc AS "Allergy Description"
FROM person, mbr, allergy
WHERE person.personid = mbr.memberid
AND mbr.memberid = allergy.memberid
ORDER BY lname, fname;


--Provide me with the members who have the best and worst attendance for the month of March. 
--Provide in the output the member's name and list their attendance hours for the month of March.
--SQL Commands: WHERE, AND, GROUP BY, HAVING SUM, MAX, SUM, OR, MIN, ORDER BY, Subqueries(at least two)
SELECT fname AS "First Name", lname AS "Last Name", SUM(ROUND(((check_out - check_in)*24),2)) AS "Attendance Hours"
FROM person, mbr, attendance
WHERE person.personid = mbr.memberid
AND mbr.memberid = attendance.memberid
GROUP BY lname, fname
HAVING SUM(ROUND(((check_out - check_in)*24),2)) = (
    SELECT MAX(SUM(ROUND(((check_out -check_in)*24),2))) FROM attendance
    WHERE ch_in_out_day > '28-FEB-2018'
    GROUP BY (memberid))
    OR SUM(ROUND(((check_out - check_in)*24),2)) = (
    SELECT MIN(SUM(ROUND(((check_out - check_in)*24),2))) FROM attendance
    WHERE ch_in_out_day > '28-FEB-2018'
    GROUP BY (memberid))
    ORDER BY "Attendance Hours" DESC, lname, fname;


--Which members have social devlopment issues, what are their grades, and 
--are their parents satisfied?
--SQL Commands: WHERE, AND, ORDER BY
SELECT fname AS "First Name", lname AS "Last Name", socialdevdesc AS "Social Development Description", 
    grade AS "Grade's Description", g_satis AS "S"
    FROM person, mbr, socialdev, academic_info 
    WHERE person.personid = mbr.memberid
    AND mbr.memberid = socialdev.socialdevid
    AND socialdev.socialdevid = academic_info.academicid
    ORDER BY lname, fname;

--I know various members take medication. Please provide me a list of all the members who take medications.
--After that, please provide me a list of JUST Jamie Simons' medication information, I know he takes quite a few of them. 
--SQL Commands: VIEW,WHERE,AND, TO_CHAR 
CREATE OR REPLACE VIEW member_medications AS 
    SELECT memberid,fname,lname,medname,amnt_medication,how_medication,time_medication 
    FROM person,medication,mbrmedinfo
    WHERE person.personid = mbrmedinfo.memberid
    AND medication.medicationid = mbrmedinfo.medicationid;

--The select statement below selects from the view above to determine Jamie Simons medication information.
SELECT fname AS "First Name", lname AS "Last Name", medname AS "Medication Name", amnt_medication 
    AS "Amount to take", how_medication AS "How to be taken", time_medication AS "Time to be taken" 
    FROM member_medications
    WHERE member_medications.lname = 'Simon'
    ORDER BY medname;

--We are trying to figure out who are most active members are. What members spend more time at our club than the average?
--SQL Commands: AVG, GROUP BY, HAVING, SUM
SELECT fname AS "First Name", lname AS "Last Name", SUM(ROUND(((check_out - check_in)*24), 2)) AS "Total Time" FROM attendance, mbr, person
WHERE person.personid = mbr.memberid 
AND attendance.memberid = mbr.memberid
GROUP BY lname, fname
HAVING SUM(ROUND(((check_out - check_in)*24), 2)) < (
SELECT AVG(SUM(ROUND(((check_out - check_in)*24), 2))) FROM attendance 
GROUP BY (attendance_id))
ORDER BY lname, fname;

--We are trying to figure out what our most popular form of payment is. 
--How much money have we collected from each payment type when collecting our membership fees?
--SQL Commands: TO_CHAR, GROUP BY, DISTINCT
SELECT DISTINCT TO_CHAR(SUM(paymentamnt), '$999,999,999') AS "Total", paymenttype AS "Type" FROM paymentinfo
    GROUP BY paymenttype;

--One of our workers will be gone next Tuesday. We want to make sure that we still have enough workers for our members. 
--How many members were here last Tuesday?
--SQL Commands: RIGHT JOIN, WHERE
SELECT COUNT(memberid) AS "Members" FROM attendance RIGHT JOIN  mbr USING (memberid)
    WHERE ch_in_out_day = '06-MAR-2018'; 

--I would like to know which members live with either their mother, father, or both. Please provide me the names of the members and their relationship.
--SQL Commands: WHERE, AND, NOT IN
SELECT fname AS "First Name", lname AS "Last Name", liveswith FROM person, mbr, familyinfo
    WHERE person.personid = mbr.memberid
    AND familyinfo.famid = mbr.famid
    AND liveswith NOT IN ('GB', 'G', 'R', 'FP')
    ORDER BY lname, fname;

--Mary Kay from LakeShore Elementary School left me a message informing me that their bus is running late.
--Please provide me the school's phone number so I can give them a call back.
--SQL Commands: WHERE, AND, INNER JOIN
SELECT fname AS "First Name", lname AS "Last Name", org_name AS "Organization Name", fd_phone AS "Phone Number" 
    FROM person INNER JOIN person_org USING (personid) INNER JOIN org USING (org_id)
    WHERE org_name = 'LakeShore Elementary School'
    AND fname = 'Mary'
    AND lname = 'Kay';

--We need to make sure all of our members have received their immunization shots. 
--Do we have any members who have not received it?
--SQL Commands: LEFT JOIN, WHERE 
SELECT COUNT(memberid) AS "Members" FROM medical_history LEFT JOIN mbr USING (memberid)
    WHERE immunizations = 'N';

--I want to make sure Riley Johnson has atleast one person as an authorized individual to pick them up after club hours. 
--Please provide me a list with their Last name and First names.
--SQL Commands: ALIAS (per.lname,perfname,aut.lname,aut.fname),WHERE,AND ORDER BY, 
SELECT relationship AS "Relationship", aut.fname AS "Authorized Ind's First Name", aut.lname AS "Authorized Ind's Last Name",
    per.fname AS "Person's First Name",
    per.lname AS "Person's Last Name"
    FROM person aut, person per, AUTHORIZED_INDIVIDUAL
    WHERE aut.personid = AUTHORIZED_INDIVIDUAL.AUTHORIZEDINDID
    AND per.personid = AUTHORIZED_INDIVIDUAL.memberid
    AND per.lname= 'Johnson'
    AND per.fname = 'Riley'
    AND auth_pickup = 'Y'
    ORDER BY aut.lname, aut.fname;
    
    
--I want the name of the member who has orientation on September 15,2018. 
--The club is preparing a welcome basket for them and I want 
--to make sure my staff members will finish it by their date. 
SELECT fname AS "Member First Name",lname AS "Member Last Name", mname AS "Member Middle Initial"
FROM consentform,person
WHERE orienschedule = TO_DATE('September 15,2018','Month DD, YYYY') 
AND consentform.memberid = person.personid
ORDER BY lname, fname, mname;


--Please give me a phone number for all the doctors in our database, I need to make sure we have updated numbers.
--SQL Commands: WHERE, EQUIJOIN,ORDER BY
SELECT fname AS "Doctor's First Name", lname AS "Doctor's Last Name",  TO_CHAR(pnumber, '999g999g9999','nls_numeric_characters=.-') AS "Phone Number" 
FROM medstaff, phone, person, person_phone
WHERE person.personid = medstaff.medstaffid
AND person.personid = person_phone.personid
AND person_phone.phoneid = phone.phoneid
AND jobtype = 'D'
ORDER BY LNAME, FNAME;

--Please provide the phone number and name of each authorized individual.
--SQL Commands: WHERE, EQUIJOIN,ORDER BY
SELECT fname AS "First Name", lname AS "Last Name",pnumber AS "Phone Number",ptype AS "Phone Type" 
FROM person,authorized_individual,phone,person_phone
WHERE person.personid = authorized_individual.authorizedindid
AND person.personid = person_phone.personid
AND phone.phoneid = authorized_individual.authphoneid
ORDER BY lname, fname;

--Please Provide me with the name of club members and the staff member that entered in their consent form.
--SQL Commands: Alias,WHERE,ORDER BY
SELECT  stf.fname AS "Staff Member's First Name", stf.lname AS "Staff Member's Last Name",
per.fname AS "Member's First Name",
per.lname AS "Member's Last Name"
FROM person stf, person per, mbr, consentform
WHERE stf.personid = consentform.staffid
AND per.personid = mbr.memberid
AND mbr.memberid = consentform.conid
ORDER BY stf.lname, stf.fname, per.lname, per.fname;

--We are looking to up-date the birthday board for this month. Please provide me with all members who have May birthdays and thier ages.
--SQL Commands: Dervied date, where, and, like, order by, round
SELECT TO_CHAR(dob, 'MM/DD/YYYY') AS "Birthday", ROUND ((CURRENT_DATE - dob)/365.25) AS "Age",fname AS "Member First Name", 
lname AS "Member Last Name", mname AS "Member Middle Initial" 
FROM dobirth, mbr, person
WHERE dobirth.birthid = mbr.birthid AND mbr.memberid = person.personid
AND dob LIKE '%%-MAY-%%%%'
ORDER BY "Birthday", "Age", lname, fname, mname;



--