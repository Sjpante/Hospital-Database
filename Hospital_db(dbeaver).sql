SELECT
  p.PatientID,
  CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
  COUNT(pr.PrescriptionID) AS PrescriptionCount
FROM PATIENT p
LEFT JOIN PRESCRIPTION pr ON pr.PatientID = p.PatientID
GROUP BY p.PatientID, p.FirstName, p.LastName
ORDER BY PrescriptionCount DESC;
