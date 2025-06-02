    drop table C##AUVAL12.TP1_CLIENT cascade constraintS;
    drop table C##AUVAL12.TP1_FORFAIT cascade constraintS;
    drop table C##AUVAL12.TP1_GUIDE cascade constraintS;
    drop table C##AUVAL12.TP1_CADEAU_PROG_FIDELITE cascade constraintS;
    drop table C##AUVAL12.TP1_ECHANGE_PROG_FIDELITE cascade constraintS;
    drop table C##AUVAL12.TP1_LIEU_EMBARQUEMENT cascade constraintS;
    drop table C##AUVAL12.TP1_ACCOMPAGNATEUR cascade constraintS;
    drop table C##AUVAL12.TP1_TRANSPORTEUR cascade constraintS;
    drop table C##AUVAL12.TP1_BUS_LOCATION cascade constraintS;
    drop table C##AUVAL12.TP1_EVENEMENT cascade constraintS;
    drop table C##AUVAL12.TP1_RESERVATION cascade constraintS;

create table C##AUVAL12.TP1_CLIENT (
    CODE_CLIENT number(5) not null,
    PRENOM_CLI varchar2(40) not null,
    NOM_CLI varchar2(40) not null,
    ADRESSE_CLI varchar2(50) null,
    VILLE_CLI varchar2(40) null,
    CODE_POSTAL_CLI varchar2(7) null,
    TEL_CLI varchar2(14) null,
    COURRIEL_CLI varchar2(40) not null,
    PHOTO_CLI varchar2(200) null,
    BOOL_CLIENT_FIDELITE number(1) default 0 not null check (BOOL_CLIENT_FIDELITE IN (0, 1)),
    constraint TP1_PK_CLIENT primary key (CODE_CLIENT),
    constraint TP1_AK_CLI_NOM_CLI_PRENOM_CLI_COURRIEL_CLI unique(NOM_CLI, PRENOM_CLI, COURRIEL_CLI),
    constraint TP1_CT_CODE_POSTAL_CLI_FORMAT check (CODE_POSTAL_CLI like '[A-Z][0-9][A-Z] [0-9][A-Z][0-9]'),
    constraint TP1_CT_TEL_CLI_FORMAT check (regexp_like(TEL_CLI, '^\([0-9]{3}\)[0-9]{3}-[0-9]{4}$')),
    constraint TP1_CT_COURRIEL_CLI_FORMAT check (COURRIEL_CLI like '%_@_%._%')
);

create table C##AUVAL12.TP1_FORFAIT (
    CODE_FORFAIT number(5) not null,
    NOM_FORFAIT varchar2(60) not null,
    NB_NUITEE number(2) not null,
    MNT_ACCOMPTE_PAR_PERSONNE number(10, 2) not null,
    MNT_FORFAIT_OCC_SIMPLE number(10, 2) null,
    MNT_FORFAIT_OCC_DOUBLE number(10, 2) null,
    MNT_FORFAIT_OCC_TRIPLE number(10, 2) null,
    MNT_FORFAIT_OCC_QUADRUPLE number(10, 2) null,
    HRE_DEPART_BUS CHAR(5) null,
    DATE_DEPART date not null,
    DATE_RETOUR date not null,
    constraint TP1_PK_FORFAIT primary key (CODE_FORFAIT),
    constraint TP1_CT_ENTIER_POSITIF_NB_NUITEE check (NB_NUITEE >= 0),
    constraint TP1_CT_HRE_DEPART_BUS_FORMAT check (regexp_like(HRE_DEPART_BUS, '^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$'))
);

-- 2. À corriger
create table C##AUVAL12.TP1_GUIDE (
    CODE_GUIDE number(5) not null,
    PRENOM_GUI varchar2(40) not null,
    NOM_GUI varchar2(40) not null,
    ADRESSE_GUI varchar2(50) null,
    VILLE_GUI varchar2(40) null,
    CODE_POSTAL_GUI varchar2(7) null,
    TEL_GUI number(10) not null,
    COURRIEL_GUI varchar2(40) null,
    constraint TP1_PK_GUIDE primary key (CODE_GUIDE),
    constraint TP1_AK_GUI_NOM_GUI_PRENOM_GUI_COURRIEL_GUI unique(NOM_GUI, PRENOM_GUI, COURRIEL_GUI),
    constraint TP1_CT_CODE_POSTAL_GUI_FORMAT check (CODE_POSTAL_GUI like '[A-Z][0-9][A-Z] [0-9][A-Z][0-9]'),
    constraint TP1_CT_TEL_GUI_FORMAT check (regexp_like(TEL_GUI, '^\([0-9]{3}\)[0-9]{3}-[0-9]{4}$')),
    constraint TP1_CT_EMAIL_FORMAT_COURRIEL_GUI check (COURRIEL_GUI like '%_@_%._%')
);

-- 1. À corriger
create table C##AUVAL12.TP1_CADEAU_PROG_FIDELITE (
    CODE_CADEAU number(5) not null,
    DESCRIPTION_CAD varchar2(50) not null,
    VALEUR_POINT_CAD number(7) not null,
    constraint TP1_PK_CADEAU_PROG_FIDELITE primary key (CODE_CADEAU),
    constraint TP1_AK_CAD_DESCRIPTION_CAD unique (DESCRIPTION_CAD),
    constraint TP1_CT_ENTIER_POSITIF_VALEUR_POINT_CAD check (VALEUR_POINT_CAD >= 0) -- contrainte check numero 1
);

create table TP1_ECHANGE_PROG_FIDELITE (
    CODE_ECHANGE number(5, 0) not null,
    CODE_CLIENT number(5, 0) not null,
    CODE_CADEAU number(5, 0) not null,
    DATE_ECHANGE date not null,
    constraint TP1_PK_ECHANGE_PROG_FIDELITE primary key (CODE_ECHANGE),
    constraint TP1_FK_ECH_CODE_CLIENT foreign key (CODE_CLIENT) references TP1_CLIENT (CODE_CLIENT),
    constraint TP1_FK_ECH_CODE_CADEAU foreign key (CODE_CADEAU) references TP1_CADEAU_PROG_FIDELITE (CODE_CADEAU)
);

create table TP1_LIEU_EMBARQUEMENT (
    CODE_LIEU_EMBARQUEMENT number(5) not null,
    NOM_LIEU_EMBARQUEMENT varchar2(40) not null,
    ADRESSE_LIE varchar2(50) null,
    VILLE_LIE varchar2(40) null,
    CODE_POSTAL_LIE varchar2(7) null,   
    ORDRE_TRI number(2) not null,
    constraint TP1_PK_LIEU_EMBARQUEMENT primary key (CODE_LIEU_EMBARQUEMENT),
    constraint TP1_AK_LIE_CODE_POSTAL_LIE unique (CODE_POSTAL_LIE),
    constraint TP1_CT_CODE_POSTAL_LIE_FORMAT check (CODE_POSTAL_LIE like '[A-Z][0-9][A-Z] [0-9][A-Z][0-9]')
);

-- a partir d'ici il y aura des foreign key

-- 2. À corriger
create table C##AUVAL12.TP1_RESERVATION (
    CODE_RESERVATION number(5) not null,
    CODE_CLIENT number(5) null,
    CODE_FORFAIT number(5) null,
    CODE_LIEU_EMBARQUEMENT number(5) null,
    QTE_OCC_SIMPLE number(2) default 0 not null,
    QTE_OCC_DOUBLE number(2) default 0 not null,
    QTE_OCC_TRIPLE number(2) default 0 not null,
    QTE_OCC_QUADRUPLE number(2) default 0 not null,
    NB_PASSAGER number(2) default 0 not null,
    BOOL_ACCOMPTE_RECU number(1) default 0 not null,
    BOOL_FORFAIT_LIBERTE number(1) default 0 not null,
    BOOL_PAYE_EN_TOTALITE number(1) default 0 not null,
    DATE_RESERVATION date default sysdate not null,
    constraint TP1_PK_RESERVATION primary key (CODE_RESERVATION),
    constraint TP1_FK_RES_CODE_CLIENT foreign key (CODE_CLIENT) references TP1_CLIENT (CODE_CLIENT),
    constraint TP1_FK_RES_CODE_LIEU_EMBARQUEMENT foreign key (CODE_LIEU_EMBARQUEMENT) references TP1_LIEU_EMBARQUEMENT (CODE_LIEU_EMBARQUEMENT),
    constraint TP1_FK_RES_CODE_FORFAIT foreign key (CODE_FORFAIT) references TP1_FORFAIT (CODE_FORFAIT),
    constraint TP1_CT_MAX10_QTE_OCC_SIMPLE check (QTE_OCC_SIMPLE between 0 AND 10), -- contrainte check numero 2
    constraint TP1_CT_MAX10_QTE_OCC_DOUBLE check (QTE_OCC_DOUBLE between 0 AND 10),
    constraint TP1_CT_MAX10_QTE_OCC_TRIPLE check (QTE_OCC_TRIPLE between 0 AND 10),
    constraint TP1_CT_MAX10_QTE_OCC_QUADRUPLE check (QTE_OCC_QUADRUPLE between 0 AND 10),
    constraint TP1_CT_BOOL_ACCOMPTE_RECU check (BOOL_ACCOMPTE_RECU IN (0, 1)), -- contrainte check numero 3
    constraint TP1_CT_BOOL_FORFAIT_LIBERTE check (BOOL_FORFAIT_LIBERTE IN (0, 1)),
    constraint TP1_CT_BOOL_BOOL_PAYE_EN_TOTALITE check (BOOL_PAYE_EN_TOTALITE IN (0, 1))
);

-- 3. À corriger
create table C##AUVAL12.TP1_ACCOMPAGNATEUR (
    CODE_ACCOMPAGNATEUR number(5) not null,
    CODE_RESERVATION number(5) not null,
    PRENOM_ACC varchar2(40) not null,
    NOM_ACC varchar2(40) not null,
    TEL_ACC number(10) not null,
    constraint TP1_PK_ACCOMPAGNATEUR primary key (CODE_ACCOMPAGNATEUR),
    constraint TP1_FK_ACC_CODE_RESERVATION foreign key (CODE_RESERVATION) references TP1_RESERVATION (CODE_RESERVATION),
    constraint TP1_CT_TEL_ACC_FORMAT check (regexp_like(TEL_ACC, '^\([0-9]{3}\)[0-9]{3}-[0-9]{4}$')) -- contrainte check numero 4
);

-- 4. À corriger
create table C##AUVAL12.TP1_TRANSPORTEUR (
    CODE_TRANSPORTEUR number(5) not null,
    NOM_TRA varchar2(40) not null,
    ADRESSE_TRA varchar2(50) null,
    VILLE_TRA varchar2(40) null,
    CODE_POSTAL_TRA varchar2(7) null,
    NOM_CONTACT varchar2(40) null,
    TEL_CONTACT number(10) null,
    constraint TP1_PK_TRANSPORTEUR primary key (CODE_TRANSPORTEUR),
    constraint TP1_AK_TRA_NOM_TRA_CODE_POSTAL_TRA unique (NOM_TRA, CODE_POSTAL_TRA),
    constraint TP1_CT_CODE_POSTAL_TRA_FORMAT check (CODE_POSTAL_TRA like '[A-Z][0-9][A-Z] [0-9][A-Z][0-9]') -- contrainte check numero 5
);

create table C##AUVAL12.TP1_BUS_LOCATION (
    CODE_LOCATION number(5) generated by default as identity not null,
    CODE_FORFAIT number(5) not null,
    CODE_TRANSPORTEUR number(5) not null,
    CODE_GUIDE number(5) not null,
    DESCRIPTION_BUS varchar2(50) null,
    CHAUFFEUR_NOM varchar2(40) not null,
    NO_SERIE_BUS CHAR(10) null,
    NB_PLACE_BUS number(3) null,
    ODOM_DEPART_BUS number(7) null,
    DATE_LOCATION DATE,
    constraint TP1_PK_BUS_LOCATION primary key (CODE_LOCATION),
    constraint TP1_FK_BUS_NO_SERIE_BUS_DATE_LOCATION unique (NO_SERIE_BUS, DATE_LOCATION),
    constraint TP1_FK_BUS_CODE_GUIDE foreign key(CODE_GUIDE) references TP1_GUIDE (CODE_GUIDE),
    constraint TP1_FK_BUS_CODE_TRANSPORTEUR foreign key(CODE_TRANSPORTEUR) references TP1_TRANSPORTEUR (CODE_TRANSPORTEUR),
    constraint TP1_FK_BUS_CODE_FORFAIT foreign key(CODE_FORFAIT) references TP1_FORFAIT (CODE_FORFAIT)
);

-- 5. À corriger
create table C##AUVAL12.TP1_EVENEMENT (
    CODE_EVENEMENT number(5) not null,
    CODE_FORFAIT number(5) not null,
    NOM_EVENEMENT varchar2(50) not null,
    PLACE_EVENEMENT varchar2(50) null,
    DATE_EVENEMENT date not null,
    VILLE_EVE varchar2(40) not null,
    TYPE_SPORT varchar2(40) not null,
    PRIX_BILLET number(10, 2) null,
    HRE_DEBUT CHAR(5) not null,
    HRE_TAILGATE CHAR(5) null,
    constraint TP1_PK_EVENEMENT primary key (CODE_EVENEMENT),
    constraint TP1_FK_EVE_CODE_FORFAIT foreign key(CODE_FORFAIT) references TP1_FORFAIT (CODE_FORFAIT),
    constraint TP1_AK_EVE_NOM_EVENEMENT_DATE_EVENEMENT unique (NOM_EVENEMENT, DATE_EVENEMENT)
);

    alter table C##AUVAL12.TP1_TRANSPORTEUR 
        add constraint TP1_CT_TEL_CONTACT_FORMA check (regexp_like (TEL_CONTACT, '^\([0-9]{3}\)[0-9]{3}-[0-9]{4}$'));
    
    alter table C##AUVAL12.TP1_EVENEMENT 
        add constraint TP1_CT_BUS_HRE_TAILGATE_FORMAT check (regexp_like(HRE_TAILGATE, '^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$'));
    
    alter table C##AUVAL12.TP1_EVENEMENT 
        add constraint TP1_CT_BUS_HRE_DEBUT_FORMAT check (regexp_like(HRE_DEBUT, '^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$'));



