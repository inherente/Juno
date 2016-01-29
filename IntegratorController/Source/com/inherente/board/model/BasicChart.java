package com.inherente.board.model;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;

@ManagedBean (name = "BasicChart" )
@RequestScoped
public class BasicChart {
	private String deltaA;
	private String deltaB;
	private String deltaC;
	private String deltaD;
	private String deltaE;
	private String deltaF;
	private String messageDocumentType;
	private String messageColumnName;

	public BasicChart () {
		setMessageColumnName("column-name");
		setMessageDocumentType("document-type");
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	public String getDeltaA() {
		return deltaA;
	}

	public void setDeltaA(String deltaA) {
		this.deltaA = deltaA;
	}

	public String getDeltaB() {
		return deltaB;
	}

	public void setDeltaB(String deltaB) {
		this.deltaB = deltaB;
	}

	public String getDeltaC() {
		return deltaC;
	}

	public void setDeltaC(String deltaC) {
		this.deltaC = deltaC;
	}

	public String getDeltaD() {
		return deltaD;
	}

	public void setDeltaD(String deltaD) {
		this.deltaD = deltaD;
	}

	public String getDeltaE() {
		return deltaE;
	}

	public void setDeltaE(String deltaE) {
		this.deltaE = deltaE;
	}

	public String getDeltaF() {
		return deltaF;
	}

	public void setDeltaF(String deltaF) {
		this.deltaF = deltaF;
	}

	public String getMessageDocumentType() {
		return messageDocumentType;
	}

	public void setMessageDocumentType(String messageDocumentType) {
		this.messageDocumentType = messageDocumentType;
	}

	public String getMessageColumnName() {
		return messageColumnName;
	}

	public void setMessageColumnName(String messageColumnName) {
		this.messageColumnName = messageColumnName;
	}

}
