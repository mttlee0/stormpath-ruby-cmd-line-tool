# Stormpath Ruby Command Line Utility

This is a command line utility using the Stormpath Ruby SDK to perform the following operations: account/group/directory/application management, simple authentication and basic security workflows (i.e. password reset). 

## Prerequisites

1. Ruby version 1.9.3 or newer is installed.
2. Stormpath Ruby SDK is installed. See https://github.com/stormpath/stormpath-sdk-ruby/tree/91a8a257ae404f302a3572049e35d9e914bde3da
3. A file named __apiKey.properties__ is located in a folder called __.stormpath__ in the local home directory. This will be used to retrieve details on the Stormpath client.

## Version History

* Version 1.0: First version with basic functionality for accounts, groups, directories, applications.

## Usage

The instructions below is the help output from the cmd line utility. Entering __ruby stormpath.rb__ will display the instructions below.

    Overview of Commands:
        account list|create|update|delete|find|group-add|send-password-reset|authenticate
        group list|create|delete
        directory list|create|delete
        application list|create|delete

    Account Command Details:
        List all accounts in an application: account list -a APPLICATION
            Example: ruby stormpath.rb account list -a "https://api.stormpath.com/v1/applications/1UjA0vsnSe1UO9s9n69F67"
        List all accounts in a directory: account list -d DIRECTORY
            Example: ruby stormpath.rb account list -d "https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V"
        List all accounts in a group: account list -g GROUP
            Example: ruby stormpath.rb account list -g "https://api.stormpath.com/v1/groups/6Ezo4XinJMAVw5Luxd4AXL"
        Create an account in a directory: account create -d DIRECTORY -e EMAIL -u USERNAME -p PASSWORD -f FIRSTNAME -s SURNAME
            Example: ruby stormpath.rb account create -d "https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V" -e "email@domain.com" -U username -p Password0 -f firstname -s surname
        Update an account by email: account update -a APPLICATION|-d DIRECTORY|-g GROUP -e EMAIL [-u USERNAME] [-p PASSWORD] [-f FIRSTNAME] [-s SURNAME] [-t STATUS]
            Example: ruby stormpath.rb account update -d "https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V" -e "email@domain.com" -u newusername
        Delete an account: account delete -a APPLICATION|-d DIRECTORY|-g GROUP -e EMAIL
            Example: ruby stormpath.rb account delete -d "https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V" -e "email@domain.com"
        Find an account by email: account find -a APPLICATION|-d DIRECTORY|-g GROUP -e EMAIL
            Example: ruby stormpath.rb account find -d "https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V" -e "mattjlee@gmail.com"
        Add an account by email from a directory|application to a group: account group-add -g GROUP -e EMAIL -a APPLICATION|-d DIRECTORY
            Example: ruby stormpath.rb account group-add -g "https://api.stormpath.com/v1/groups/4eDD2MDlTI5jWiap3gh1ql" -d "https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V" -e "email@domain.com"
        Send password reset email to an account: account send-password-reset -a APPLICATION -e EMAIL
            Example: ruby stormpath.rb account send-password-reset -a "https://api.stormpath.com/v1/applications/1UjA0vsnSe1UO9s9n69F67" -e "mattjlee@gmail.com"
        Authenticate an account by username and password: account authenticate -a APPLICATION -u USERNAME -p PASSWORD
            Example: ruby stormpath.rb account authenticate -a "https://api.stormpath.com/v1/applications/1UjA0vsnSe1UO9s9n69F67" -u myusername -p Password0

    Group Command Details:
        List all groups in a directory: group list -d DIRECTORY
            Example: ruby stormpath.rb group list -d "https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0Vi"
        Create a group: group create -d DIRECTORY -n NAME --description DESCRIPTION
            Example: ruby stormpath.rb group create -d "https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0Vi" -n "My Group A" --description "My Group A Descriptioni"
        Delete a group: group delete -d DIRECTORY -g GROUP
            Example: ruby stormpath.rb group delete -d "https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V" -g "https://api.stormpath.com/v1/groups/4eDD2MDlTI5jWiap3gh1ql"

    Directory Command Details:
        List all directories: directory list
            Example: ruby stormpath.rb directory list
        Create a directory: directory create -n NAME --description DESCRIPTION
            Example: ruby stormpath.rb directory create -n "Test Dir A" --description "Test Dir A Desc"
        Delete a directory: directory delete -d DIRECTORY
            Example: ruby stormpath.rb directory delete -d "https://api.stormpath.com/v1/directories/2abJwWZAPcPpzaREKrHSOZ"

    Application Command Details:
        List all applications: application -list
            Example: ruby stormpath.rb application list
        Create an application: application create -n NAME --description DESCRIPTION
            Example: ruby stormpath.rb application create -n "Test App A" --description "Test App A Desc"
        Delete an application: application delete -a APPLICATION
            Example: ruby stormpath.rb application delete -a "https://api.stormpath.com/v1/applications/32BzL7MK0DJxlzZseZtunz"

    List of all arguments/options:
        -a, --application APPLICATION    the application href
        -g, --group GROUP                the group href
        -d, --directory DIRECTORY        the directory href
        -n, --name NAME                  the name of the application|directory|group
            --description DESCRIPTION    the description of the application|directory|group
        -e, --email EMAIL                the email
        -u, --username USERNAME          the username
        -p, --password PASSWORD          the password
        -f, --firstname FIRSTNAME        the first name
        -s, --surname SURNAME            the surname
        -t, --status STATUS              THE status of the account; possible values: 'enabled', 'disabled'
        
## Example Usage

### List all accounts in a directory

#### Input

    ruby stormpath.rb account list -d "https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V"

#### Output

    Email: e@a.com
    Username: e
    First name: first
    Last name: last
    Status: ENABLED
    Email: john@gmail.com
    Username: johnsmith
    First name: Johnathan
    Last name: Smith
    Status: ENABLED
    Email: email@domain.com
    Username: username
    First name: firstname
    Last name: surname
    Status: ENABLED
    
### Create an account

#### Input
  
     ruby stormpath.rb account create -d "https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V" -e "email@domain.com" -u "username" -p "ABCDabcd0" -f "firstname" -s "surname"
     
#### Output
   
     Account created.
