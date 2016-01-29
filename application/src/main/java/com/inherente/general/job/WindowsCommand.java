package com.inherente.general.job;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.logging.Logger;

public abstract class WindowsCommand {
	Process p= null;
	BufferedReader in ;
	static Logger log = Logger.getLogger(WindowsCommand.class.getName());
	public void command (String fullpathCommand) {
		String line;
        try {  
            p= Runtime.getRuntime().exec("cmd /c start "+ fullpathCommand);  
            in = new BufferedReader(  new InputStreamReader(p.getInputStream()));  
            line = null;  
            while ((line = in.readLine()) != null) {  
                log.info(line);  
            }  
        } catch (IOException e) {  
            e.printStackTrace();  
        }
	}
	public abstract boolean commandLine (String command) ;

}
