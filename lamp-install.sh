#!/bin/bash
#
# Checks for and installs all requirements for
# a LAMP server stack.
#
# By John Shanahan
#################################################

#################################################
# Header/name
#################################################
printf "\n####################\n"
printf "#  Lamp-install.sh #\n# By John Shanahan #\n"
printf "####################\n\n"

#################################################
# Requires run as root (or sudo)
#################################################
printf "Checking UID...\n"
if (( EUID != 0 )); then
	printf "You must be root to do this, Please use 'sudo ./lamp-install'.\n" 1>&2
	exit 10
else
	printf "User is root ...\n"
fi

#################################################
# Installing LAMP or Debugging?
#################################################
printf "\nAre you installing, debugging, or removing an existing LAMP server stack?\n"
printf "(I)nstalling LAMP stack.\n"
printf "(D)ebugging a current installation.\n"
printf "(R)emoving a current LAMP installation.\n"
printf "(Q)uit.\n"
printf "> "
	read install_debug_rm

#################################################
# Installing LAMP server stack
#################################################
if [[ ( "$install_debug_rm" = i ) || ( "$install_debug_rm" = I ) ]]
then
	# Update and Upgrade
	printf "\nUpdating ...\n"
	apt-get -qqq update

	##############################
	#  Install required packages #
	##############################
	apt-get -qqq install apache2 php5 libapache2-mod-php5 libapache2-mod-auth-mysql mysql-server php5-mysql phpmyadmin

	#############################
	#     Configure packages    #
	#############################

	printf "\nWould you like to add 'ServerName localhost' to /etc/apache2/conf.d/fqdn? (y/n)\n"
	printf "If this is a development box or you're not sure type y to be safe.\n"
	printf "> "
	read serv_local

	if [[ ( "$serv_local" = y ) || ( "$serv_local" = Y ) ]]
	then
		echo "ServerName localhost" >> /etc/apache2/conf.d/fqdn
	else
		printf "Nothing was added to /etc/apache2/conf.d/fqdn ...\n"
	fi

	######################
	#   Restart Apache   #
	######################
	printf "\nRestarting apache2 ...\n"
	/etc/init.d/apache2 restart

	########################
	#   How to configure   #
	########################
	printf "\n\nTo configure MySQL type $ mysql -u root\n\n"
	printf "For other computers on your network to see the server\n"
	printf "edit the 'bind-address = 127.0.0.1' line in\n"
	printf "your /etc/mysql/my.cnf to your IP address.\n\n"
	printf "To get PHP to work with MySQL you need to uncomment the\n"
	printf "line in /etc/php5/apache2/php.ini that says ';extension=mysql.so'\n\n"
fi

#################################################
# Debugging options
#################################################
if [[ ( "$install_debug_rm" = d ) || ( "$install_debug_rm" = D ) ]]
then
	printf "Debuggin ...\n"
fi


#################################################
# Removing LAMP stack
#################################################
if [[ ( "$install_debug_rm" = r ) || ( "$install_debug_rm" = R ) ]]
then
	printf "Removing LAMP ...\n"
	
	apt-get purge -qqq apache2 php5 libapache2-mod-php5 mysql-server php5-mysql libapace2-mod-auth-mysql phpmyadmin

	printf "LAMP stack removed ...\n"
	exit 10
fi

if [[ ( "$install_debug_rm" = q ) || ( "$install_debug_rm" = Q ) ]]
then
	printf "Quitting ...\n"
	exit 0
fi






