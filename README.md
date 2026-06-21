# **#HIPS RISC Based CPU**

Stands for hundreds of instructions per second, similar to MIPS. It's not actually hundreds of instructions per seconds, it's just a nice word I like. It supports 32 bit #width instructions and contain the common MIPS instructions like add, sub, jr, j, beq, etc. 

Currently it is single cycle, unpipelined but those versions are in the works and have an estimated completion time of 1-2 months. I have provided all the SV files and the testbench file to verify the design. I have drawn out the architecture on a piece of paper but have no gotten around the time to polish and post it. It is slightly different than MIPs in some aspects so if you look into the design files, you will notice some quirks.





# **#Assembler**

AN ASSEMBER IS IN THE WORKS!

I am working on making an assembler for this custom ISA, but it will take 3-4 weeks so i advise you to just manually play around with it on your own.



I hope you can find the beauty in something as simple as this, I loved every part in making it!



The RTL folder holds the SV files for synthesis and the sim holds the testbench. The documentation for the support instructions are in the HIPSISA.md file so browse it to start making programs. Enjoy! 

