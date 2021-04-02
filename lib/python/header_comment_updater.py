import os
import re

from datetime import datetime

HOME = "/home/ppolcz/"
ROOT = HOME + "_/"
PATH = ROOT + "5_Sztaki20_Main/"
# PATH = ROOT + "4_gyujtemegy/11_CCS/2021_COVID19_analizis/study7_trackin/"

BACKUP_DIR = HOME + "/Templates/Backup_" + datetime.now().strftime('%Y_%m_%d_%H_%M_%S')

# Pattern for `%  File: qarm_GP_tune_evaluate_DT.m`
PATTERN_File = "(%  File:) .*"

# Pattern for `%  Directory: 5_Sztaki20_Main/Models/01_QArm/50_GP_for_DT`
PATTERN_Directory = "(%  Directory:) .*"

result = [os.path.join(dp, f) for dp, dn, filenames in os.walk(PATH) for f in filenames if os.path.splitext(f)[1] == '.m']

for scriptname in result:
    # print(scriptname)
    
    with open(scriptname, 'r+') as f:
        text = f.read()

        # Filename and dirname
        scriptname = scriptname.replace(ROOT,"")        
        dirname = os.path.dirname(scriptname)
        basename = os.path.basename(scriptname)
        
        # Generate backup dir and file names
        backup_dirname = BACKUP_DIR + "/" + dirname
        backup_scriptname = backup_dirname + "/" + basename
        
        # Create backup dirs
        os.makedirs(backup_dirname, exist_ok=True)
        
        # Save to backup dir
        bf = open(backup_scriptname, "a")
        bf.write(text)
        bf.close()
    
        # Replace text in file content
        text = re.sub(PATTERN_File, r"\1 %s" % basename, text, 1)
        text = re.sub(PATTERN_Directory, r"\1 %s" % dirname, text, 1)
                    
        # Write out the result to the original file
        f.seek(0)
        f.write(text)
        f.truncate()
        f.close()
    
    
