DROP TABLE localisation;
DROP TABLE etablissement;
DROP TABLE formation CASCADE;
DROP TABLE association;
DROP TABLE import;
DROP SEQUENCE No_Loc;
DROP SEQUENCE No_Etab;
DROP TABLE filles;
DROP TABLE bg_vs_bt_vs_bp;
DROP TABLE admis_mention;

\echo "Création de la table import"

CREATE TABLE import (
n1 int, n2 text, n3 char(8), n4 text, n5 text, n6 text, n7 text, n8 text,
n9 text, n10 text,n11 text, n12 text, n13 text, n14 text, n15 text, n16 text, n17 text,
n18 int, n19 int, n20 int, n21 int, n22 text, n23 int, n24 int, n25 int, n26 int, n27 int, n28 int,
n29 int, n30 int, n31 int, n32 int, n33 int, n34 int, n35 int,
n36 int, n37 text, n38 text, n39 int, n40 int, n41 int, n42 int,
n43 int, n44 int, n45 int, n46 int, n47 int, n48 int, n49 int,
n50 int, n51 numeric, n52 numeric, n53 numeric, n54 text, n55 int, n56 int,
n57 int, n58 int, n59 int, n60 int, n61 int, n62 int, n63 int,
n64 int, n65 int, n66 numeric, n67 int, n68 int, n69 int, n70 text,
n71 text, n72 int, n73 text, n74 float, n75 numeric, n76 text, n77 text,
n78 numeric, n79 text, n80 text, n81 float, n82 numeric, n83 text, n84 text,
n85 numeric, n86 text, n87 text, n88 text, n89 numeric, n90 text, n91 text,
n92 numeric, n93 text, n94 text, n95 numeric, n96 numeric, n97 numeric, n98 numeric,
n99 numeric, n100 numeric, n101 numeric, n102 text, n103 text, n104 text, n105 text, n106 text, n107 text, n108 text, n109 text, n110 int, n111 text, n112 text, n113 text,
n114 numeric, n115 numeric, n116 numeric, n117 char(5), n118 char(5));

\! curl -o ./data-brut.csv https://data.enseignementsup-recherche.gouv.fr/api/explore/v2.1/catalog/datasets/fr-esr-parcoursup/exports/csv?lang=fr&timezone=Europe%2FBerlin&use_labels=true&delimiter=%3B wait

\! iconv -t UTF-8 ./data-brut.csv

\! cat ./data-brut.csv | sed 1d > ./data.csv

\copy import FROM ./data.csv DELIMITER ';'

\! wc ./data.csv

\echo "Création de la table localisation"

CREATE SEQUENCE No_Loc START 1;

CREATE TABLE localisation(No_Loc, Code_départemental, Département, Région, Académie, Commune) AS SELECT DISTINCT nextval('No_Loc'), n5, n6, n7, n8, n9 FROM import;

ALTER TABLE localisation ADD PRIMARY KEY(No_Loc);

\echo '\n'
\echo "Création de la table etablissement"

CREATE SEQUENCE No_Etab START 1;
CREATE TABLE etablissement(No_Etab, Code_UAI, Nom, Etablissement_ID_paysage, Composante_ID_paysage) AS SELECT DISTINCT nextval('No_Etab'), n3, n4, n117, n118 FROM import;

ALTER TABLE etablissement ADD PRIMARY KEY(No_Etab, Code_UAI);

\echo '\n'
\echo "Création de la table formation en cours..."

CREATE TABLE formation(Code_Formation, Filiere, Filière_détaillée, Filière_précise, Capacité, Taux_accès) AS SELECT DISTINCT n110, n10, n13, n14, n18, n113 FROM import;

ALTER TABLE formation ADD PRIMARY KEY(Code_Formation);

\echo '\n'
\echo "Création de la table association en cours..."

CREATE TABLE association(Code_Formation, Region, Admis_NB, Admis_NB_G, Admis_NB_T, Admis_NB_P, Pourc_Admis_proposition_admis_à_ouverture_proce_prin, Pourc_Admis_proposition_av_fin_proc_prin, Admis_ayant_prop_admis_ouverture_proc_prin, Eff_Tot_Admis, Admis_ayant_prop_av_fin_proc_prin, Pourc_Admis_NB_boursiers, Eff_Admis_NB_boursiers) AS SELECT DISTINCT n110, n7, n56, n57, n58, n59, n74, n76, n51, n47, n53, n81, n55 FROM import;

ALTER TABLE association ADD FOREIGN KEY(Code_Formation) 
REFERENCES formation(Code_Formation) ON UPDATE CASCADE ON DELETE CASCADE;

\echo '\n'
\echo "Creation des tables pour la partie stat en cours..."

CREATE TABLE filles(Code_UAI , Code_Formation , Region , Eff_total_candidat_form ,Eff_Candidates_par_form , Dont_eff_candidates_admises , Dont_eff_admises_issues_meme_etab , Pourc_admis_dont_filles) AS SELECT DISTINCT n3, n110, n7, n19, n20, n48, n71, n77 FROM import;

ALTER TABLE filles ADD PRIMARY KEY(Code_Formation);

CREATE TABLE bg_vs_bt_vs_bp(Code_Formation, Selectivite , Region, Eff_cand_généraux_phase_principale , Eff_cand_techno_phase_principale , Eff_cand_prof_phase_princ , Eff_cand_généraux_phase_complémentaire , Eff_cand_techno_phase_complémentaire , Eff_cand_pro_phase_complémentaire , Eff_cand_généraux_par_étab , Eff_cand_techno_par_etab, Eff_cand_pro_par_etab , Eff_admis , Eff_admis_généraux , Eff_admis_techno , Eff_admis_pro ) AS SELECT DISTINCT n110, n11, n7, n23, n25, n27, n31, n32, n33, n39, n41, n43, n56, n57, n58, n59 FROM import;

ALTER TABLE bg_vs_bt_vs_bp ADD PRIMARY KEY(Code_Formation);

CREATE TABLE admis_mention(Code_Formation, Eff_admis, Eff_admis_généraux_ayant_mention, Eff_admis_techno_ayant_mention, Eff_admis_pro_ayant_mention) AS SELECT DISTINCT n110, n56, n67, n68, n69 FROM import;

ALTER TABLE admis_mention ADD PRIMARY KEY(Code_Formation);

\echo '\n'
\echo "Creation et importation des données finies"

\i ./requete.sql
