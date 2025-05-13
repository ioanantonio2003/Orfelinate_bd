# 🏠 Proiect Baze de Date – Orfelinate si Donatori

Acest proiect reprezinta un model de baza de date pentru gestionarea informatiilor legate de orfelinate, angajati, orfani, donatori si organizatori de evenimente, incluzand relatiile relevante dintre entitati.

---

## 🧩 Structura Bazei de Date

Modelul este ilustrat in diagrama ER de mai jos:

![image](https://github.com/user-attachments/assets/5737052e-f2d8-49c5-8943-030d5f6994d7)


---

## 🗂️ Tabelele principale

- **ORFELINATE**: Informatii despre orfelinate, inclusiv adresa si sectorul in care se afla.
- **ANGAJATI**: Angajatii care lucreaza in cadrul orfelinatelor.
- **ORFANI**: Copiii care locuiesc in orfelinate.
- **DONATORI**: Persoane sau organizatii care ofera donatii catre orfelinate.
- **ORGANIZATORI**: Entitati sau persoane care organizeaza evenimente pentru orfani.
- **SECTOARE**: Informatii despre sectoarele administrative .

---

## 🔗 Relatii

- **DONEAZA**: Relatie de tip **MANY-TO-MANY** intre DONATORI si ORFELINATE, care include detalii despre donatie (data, suma).
- **PARTICIPA_LA_EVENIMENTE**: Relatie **MANY-TO-MANY** intre ORFANI si ORGANIZATORI, ce stocheaza date despre evenimentele la care participa un orfan.
- Fiecare **ANGAJAT** lucreaza intr-un **ORFELINAT** (relatie de tip MANY-TO-ONE).
- Fiecare **ORFAN** locuieste intr-un **ORFELINAT** (relatie de tip MANY-TO-ONE).
- Fiecare **ORFELINAT** se afla intr-un **SECTOR**.

---

## 📁 Fisiere incluse

- `Creare&&Inserare.sql` – Script SQL care creeaza toate tabelele si relatiile definite in diagrama.
- `script.sql` - aplicatie a diagramaei
- `DiagramaOrfelinate.png` – Diagrama ER a bazei de date.

---

## 💡 Observatii

- Diagrama este de tip **conceptual**.
- Scriptul SQL este compatibil cu SGBD-uri precum **MySQL**, **PostgreSQL** sau **Oracle**, cu adaptarile necesare de sintaxa.
