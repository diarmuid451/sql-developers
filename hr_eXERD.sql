desc JOBS; --EMP_JOB_FK , JHIST_JOB_FK
--JOB_ID     NOT NULL VARCHAR2(10) 
--JOB_TITLE  NOT NULL VARCHAR2(35) 
--MIN_SALARY          NUMBER(6)    
--MAX_SALARY          NUMBER(6)   

desc EMPLOYEES; --EMP_MANAGER_FK,   --EMP_DEPT_FK ,--EMP_JOB_FK
--EMPLOYEE_ID    NOT NULL NUMBER(6)    
--FIRST_NAME              VARCHAR2(20) 
--LAST_NAME      NOT NULL VARCHAR2(25) 
--EMAIL          NOT NULL VARCHAR2(25) 
--PHONE_NUMBER            VARCHAR2(20) 
--HIRE_DATE      NOT NULL DATE         
--JOB_ID         NOT NULL VARCHAR2(10) 
--SALARY                  NUMBER(8,2)  
--COMMISSION_PCT          NUMBER(2,2)  
--MANAGER_ID              NUMBER(6)    
--DEPARTMENT_ID           NUMBER(4)   

desc JOB_HISTORY; --JHIST_DEPT_FK, --JHIST_EMP_FK, --JHIST_JOBS_FK
--EMPLOYEE_ID   NOT NULL NUMBER(6)    
--START_DATE    NOT NULL DATE         
--END_DATE      NOT NULL DATE         
--JOB_ID        NOT NULL VARCHAR2(10) 
--DEPARTMENT_ID          NUMBER(4)     

desc DEPARTMENTS; --DEPT_MGR_FK, --DEPT_LOC_FK 
--DEPARTMENT_ID   NOT NULL NUMBER(4)    
--DEPARTMENT_NAME NOT NULL VARCHAR2(30) 
--MANAGER_ID               NUMBER(6)    
--LOCATION_ID              NUMBER(4)

desc LOCATIONS; --LOC_C_ID_FK
--LOCATION_ID    NOT NULL NUMBER(4)    
--STREET_ADDRESS          VARCHAR2(40) 
--POSTAL_CODE             VARCHAR2(12) 
--CITY           NOT NULL VARCHAR2(30) 
--STATE_PROVINCE          VARCHAR2(25) 
--COUNTRY_ID              CHAR(2) 

desc COUNTRIES; --COUNTR_REG_FK
--COUNTRY_ID   NOT NULL CHAR(2)      
--COUNTRY_NAME          VARCHAR2(40) 
--REGION_ID             NUMBER

desc REGIONS; 
--REGION_ID   NOT NULL NUMBER       
--REGION_NAME          VARCHAR2(25)