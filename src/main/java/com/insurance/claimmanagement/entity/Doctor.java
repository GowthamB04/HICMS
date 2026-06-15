package com.insurance.claimmanagement.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "doctors")
public class Doctor {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long doctorId;
    
    @Column(nullable = false, length = 100)
    private String doctorName;
    
    @Column(nullable = false, length = 50)
    private String specialization; // Cardiology, Orthopedics, etc.
    
    @Column(name = "registration_number", nullable = false, length = 50)
    private String registrationNumber; // e.g., medical council registration
    
    // Doctor table stores only frontend fields: name, specialization, registration number.
    
    // Constructor
    public Doctor() {
    }
    
    public Doctor(String doctorName, String specialization, String registrationNumber) {
        this.doctorName = doctorName;
        this.specialization = specialization;
        this.registrationNumber = registrationNumber;
    }
    
    // Getters and Setters
    public Long getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(Long doctorId) {
        this.doctorId = doctorId;
    }
    
    public String getDoctorName() {
        return doctorName;
    }
    
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
    
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
    
    public String getRegistrationNumber() {
        return registrationNumber;
    }

    public void setRegistrationNumber(String registrationNumber) {
        this.registrationNumber = registrationNumber;
    }
    
    
    @Override
    public String toString() {
        return "Doctor{" +
                "doctorId=" + doctorId +
                ", doctorName='" + doctorName + '\'' +
                ", specialization='" + specialization + '\'' +
                ", registrationNumber='" + registrationNumber + '\'' +
                '}';
    }
}
