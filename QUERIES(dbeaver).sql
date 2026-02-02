
-- =============================================
-- Query A: Single table
-- =============================================

SELECT
PatientID,
FirstName,
LastName,
AdmissionDate,
DischargeDate
FROM PATIENT
ORDER BY AdmissionDate DESC;

-- =============================================
-- Query B: Multiple tables
-- =============================================

SELECT
p.PatientID,
CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
w.WardNumber,
wg.WingName,
CONCAT(mc.FirstName, ' ', mc.LastName) AS ConsultantName,
p.AdmissionDate,
p.DischargeDate
FROM PATIENT p
JOIN WARD w ON p.WardID = w.WardID
JOIN WING wg ON w.WingID = wg.WingID
JOIN MEDICAL_CONSULTANT mc ON p.ConsultantID = mc.StaffID
ORDER BY wg.WingName, w.WardNumber, p.PatientID;

-- =============================================
-- Query C: GROUP BY
-- =============================================

SELECT
p.PatientID,
CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
COUNT(pr.PrescriptionID) AS PrescriptionCount
FROM PATIENT p
LEFT JOIN PRESCRIPTION pr
ON pr.PatientID = p.PatientID
GROUP BY
p.PatientID,
p.FirstName,
p.LastName
ORDER BY PrescriptionCount DESC;



