require 'stormpath-sdk'
require 'optparse'


# Sets up the Stormpath client based on the apiKey.properties file. Returns a Stormpath::Client object.
def myinitialize()
  # TODO: To improve flexibility, we can allow the user to specify the path to the file.
  client = Stormpath::Client.new api_key_file_location: File.join(ENV['HOME'], '.stormpath', 'apiKey.properties')
  return client
end

# Parses the command line options, outputs help/usage information for the command line utility. Returns an OptionParser object.
def help(options)
  # Note: This is not the ideal usage of OptionParser. A limitation of OptionParser is different commands must share the same options. Thor would be a better candidate to handle this use case.
  opt_parser = OptionParser.new do |opt|
    opt.banner = "Usage: stormpath.rb OBJECT ACTION ARGUMENTS"
    opt.separator  ""
    opt.separator  "Overview of Commands:"
    opt.separator  "    account list|create|update|delete|find|group-add|send-password-reset|authenticate"
    opt.separator  "    group list|create|delete"
    opt.separator  "    directory list|create|delete"
    opt.separator  "    application list|create|delete"
    opt.separator  ""

    # Details and examples on all the commands for the account object
    opt.separator  "Account Command Details:" 
    opt.separator  "    List all accounts in an application: account list -a APPLICATION"
    opt.separator  "        Example: ruby stormpath.rb account list -a \"https://api.stormpath.com/v1/applications/1UjA0vsnSe1UO9s9n69F67\""
    opt.separator  "    List all accounts in a directory: account list -d DIRECTORY"
    opt.separator  "        Example: ruby stormpath.rb account list -d \"https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V\""
    opt.separator  "    List all accounts in a group: account list -g GROUP"
    opt.separator  "        Example: ruby stormpath.rb account list -g \"https://api.stormpath.com/v1/groups/6Ezo4XinJMAVw5Luxd4AXL\""
    opt.separator  "    Create an account in a directory: account create -d DIRECTORY -e EMAIL -u USERNAME -p PASSWORD -f FIRSTNAME -s SURNAME"
    opt.separator  "        Example: ruby stormpath.rb account create -d \"https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V\" -e \"email@domain.com\" -U username -p Password0 -f firstname -s surname"
    opt.separator  "    Update an account by email: account update -a APPLICATION|-d DIRECTORY|-g GROUP -e EMAIL [-u USERNAME] [-p PASSWORD] [-f FIRSTNAME] [-s SURNAME] [-t STATUS]"
    opt.separator  "        Example: ruby stormpath.rb account update -d \"https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V\" -e \"email@domain.com\" -u newusername"
    opt.separator  "    Delete an account: account delete -a APPLICATION|-d DIRECTORY|-g GROUP -e EMAIL"
    opt.separator  "        Example: ruby stormpath.rb account delete -d \"https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V\" -e \"email@domain.com\""
    opt.separator  "    Find an account by email: account find -a APPLICATION|-d DIRECTORY|-g GROUP -e EMAIL"
    opt.separator  "        Example: ruby stormpath.rb account find -d \"https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V\" -e \"mattjlee@gmail.com\""
    opt.separator  "    Add an account by email from a directory|application to a group: account group-add -g GROUP -e EMAIL -a APPLICATION|-d DIRECTORY"
    opt.separator  "        Example: ruby stormpath.rb account group-add -g \"https://api.stormpath.com/v1/groups/4eDD2MDlTI5jWiap3gh1ql\" -d \"https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V\" -e \"email@domain.com\""    
    opt.separator  "    Send password reset email to an account: account send-password-reset -a APPLICATION -e EMAIL" 
    opt.separator  "        Example: ruby stormpath.rb account send-password-reset -a \"https://api.stormpath.com/v1/applications/1UjA0vsnSe1UO9s9n69F67\" -e \"mattjlee@gmail.com\""
    opt.separator  "    Authenticate an account by username and password: account authenticate -a APPLICATION -u USERNAME -p PASSWORD"
    opt.separator  "        Example: ruby stormpath.rb account authenticate -a \"https://api.stormpath.com/v1/applications/1UjA0vsnSe1UO9s9n69F67\" -u myusername -p Password0"
    opt.separator  ""

    # # Details and examples on all the commands for the group object
    opt.separator  "Group Command Details:"
    opt.separator  "    List all groups in a directory: group list -d DIRECTORY"
    opt.separator  "        Example: ruby stormpath.rb group list -d \"https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0Vi\""
    opt.separator  "    Create a group: group create -d DIRECTORY -n NAME --description DESCRIPTION"
    opt.separator  "        Example: ruby stormpath.rb group create -d \"https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0Vi\" -n \"My Group A\" --description \"My Group A Descriptioni\""
    opt.separator  "    Delete a group: group delete -d DIRECTORY -g GROUP"
    opt.separator  "        Example: ruby stormpath.rb group delete -d \"https://api.stormpath.com/v1/directories/1UjvZW6oLfCn7uVdrhzQ0V\" -g \"https://api.stormpath.com/v1/groups/4eDD2MDlTI5jWiap3gh1ql\""
    opt.separator  ""

    # Details and examples on all the commands for the directory object
    opt.separator  "Directory Command Details:"
    opt.separator  "    List all directories: directory list"
    opt.separator  "        Example: ruby stormpath.rb directory list"
    opt.separator  "    Create a directory: directory create -n NAME --description DESCRIPTION"
    opt.separator  "        Example: ruby stormpath.rb directory create -n \"Test Dir A\" --description \"Test Dir A Desc\""
    opt.separator  "    Delete a directory: directory delete -d DIRECTORY"
    opt.separator  "        Example: ruby stormpath.rb directory delete -d \"https://api.stormpath.com/v1/directories/2abJwWZAPcPpzaREKrHSOZ\"" 
    opt.separator  ""

    # Details and examples on all the commands for the application object
    opt.separator  "Application Command Details:"
    opt.separator  "    List all applications: application -list"
    opt.separator  "        Example: ruby stormpath.rb application list"
    opt.separator  "    Create an application: application create -n NAME --description DESCRIPTION"
    opt.separator  "        Example: ruby stormpath.rb application create -n \"Test App A\" --description \"Test App A Desc\""
    opt.separator  "    Delete an application: application delete -a APPLICATION"
    opt.separator  "        Example: ruby stormpath.rb application delete -a \"https://api.stormpath.com/v1/applications/32BzL7MK0DJxlzZseZtunz\"" 
   
    # List of all the arguments/options for every command
    opt.separator ""
    opt.separator "List of all arguments/options:"

    opt.on("-a","--application APPLICATION","the application href") do |application|
      options[:application] = application
    end

    opt.on("-g","--group GROUP","the group href") do |group|
      options[:group] = group
    end

    opt.on("-d","--directory DIRECTORY","the directory href") do |directory|
      options[:directory] = directory
    end
   
    opt.on("-n", "--name NAME", "the name of the application|directory|group") do |name|
      options[:name] = name
    end

    opt.on("--description DESCRIPTION", "the description of the application|directory|group") do |description|
      options[:description] = description
    end

    opt.on("-e", "--email EMAIL", "the email") do |email|
      options[:email] = email
    end

    opt.on("-u", "--username USERNAME", "the username") do |username|
      options[:username] = username
    end

    opt.on("-p", "--password PASSWORD", "the password") do |password|
      options[:password] = password
    end

    opt.on("-f", "--firstname FIRSTNAME", "the first name") do |firstname|
      options[:firstname] = firstname
    end

    opt.on("-s", "--surname SURNAME", "the surname") do |surname|
      options[:surname] = surname
    end

    opt.on("-t", "--status STATUS", "THE status of the account; possible values: 'enabled', 'disabled'") do |status|
      options[:status] = status
    end
  end

  return opt_parser
end

# List all the accounts for an application|group|directory.
def list_accounts(client, options)
  accounts = get_accounts(client, options)
  if accounts.nil?
    return
  end

  accounts.each do |acc|
    print_account(acc)
  end
end

# Retrieves an account by email. Returns an Account object.
def get_account(client, options)
  accounts = get_accounts(client, options)
  if accounts.nil?
    return nil
  end

  return find_account(accounts, options[:email])
end

# Displays details of an account by email. Returns nothing.
def get_account_and_display(client, options)
  account = get_account(client, options)
  if !account.nil?
    print_account(account)
  else
    puts "Account not found."
    return
  end
end

# Creates an account in a directory. Returns nothing.
def create_account(client, options)
  if options[:directory].nil? or options[:email].nil? or options[:username].nil? or options[:password].nil? or options[:firstname].nil? or options[:surname].nil?
    puts "Missing arguments"
    return
  end

  directory = client.directories.get options[:directory]
  begin
    account = Stormpath::Resource::Account.new({
      given_name: options[:firstname],
      surname: options[:surname],
      email: options[:email],
      username: options[:username],
      password: options[:password],
      status: (options[:status] == "disabled" ? Stormpath::Resource::Status::DISABLED : Stormpath::Resource::Status::ENABLED)
    }, client)
    account = directory.create_account account, false
    puts "Account created."

  rescue Stormpath::Error => e
    print_error(e)
  end
end

# Creates an application. Returns nothing.
def create_application(client, options)
  if options[:name].nil? or options[:description].nil?
    puts "Missing arguments"
  end
  
  application = client.applications.create({
    name: options[:name],
    description: options[:description]
  })
  puts "Application created."

  #TODO: Add exception handling
end

# Creates a directory. Returns nothing.
def create_directory(client, options)
  if options[:name].nil? or options[:description].nil?
    puts "Missing arguments"
  end

  directory = client.directories.create({
    name: options[:name],
    description: options[:description]
  })
  puts "Directory created."

  #TODO: Add exception handling
end

# Creates a group in a directory. Returns nothing.
def create_group(client, options)
  if options[:directory].nil? or options[:name].nil? or options[:description].nil?
    puts "Missing arguments"
  end
  
  directory = client.directories.get options[:directory]

  group = directory.groups.create({
    name: options[:name],
    description: options[:description]
  })
  puts "Group created."

  #TODO: Add exception handling
end

# Authenticates an account by username and password. Returns nothing.
def authenticate_account(client, options)
  if options[:application].nil?  or options[:username].nil? or options[:password].nil? 
    puts "Missing arguments"
    return
  end

  application = client.applications.get options[:application]
  request = Stormpath::Authentication::UsernamePasswordRequest.new options[:username], options[:password]
  begin
    result = application.authenticate_account request
    puts "Authentication: SUCCESS"
    puts "Account Href: " + result.account.href
  
  rescue Stormpath::Error => e
    puts "Authentication: FAILURE"
    print_error(e)
  end
end 

# Updates the details of an account. Returns nothing.
def update_account(client, options)
  accounts = get_accounts(client, options)
  if accounts.nil?
    return
  end

  account = find_account(accounts, options[:email])
  if !account.nil?
    if !options[:firstname].nil?
      account.given_name = options[:firstname]
    end
    if !options[:surname].nil?
      account.surname = options[:surname]
    end
    if !options[:username].nil?
      account.username = options[:username]
    end 
    if !options[:password].nil?
      account.password = options[:password]
    end
    if !options[:status].nil?
      account.status = (options[:status] == "disabled" ? Stormpath::Resource::Status::DISABLED : Stormpath::Resource::Status::ENABLED)
    end

    begin
      account.save
      puts "Account updated."
    rescue Stormpath::Error => e
      print_error(e)
    end
  else
    puts "Account not found"
    return
  end
end

# Deletes an account by email. Returns nothing.
def delete_account(client, options)
  accounts = get_accounts(client, options)
  if accounts.nil?
    return
  end

  account = find_account(accounts, options[:email])
  if !account.nil?
    account.delete
    puts "Account deleted."
  else
    puts "Account not found."
    return
  end
end  

# Get a collection of accounts by application or directory or group. Returns collection of accounts.
def get_accounts(client, options)
  # TODO: Add exception handling 
  if !options[:application].nil?
    application = client.applications.get options[:application]
    return application.accounts
  elsif !options[:directory].nil?
    directory = client.directories.get options[:directory]
    return directory.accounts
  elsif !options[:group].nil?
    group = client.groups.get options[:group]
    return group.accounts
  else
    puts "Missing arguments"
    return nil
  end  
end

# Adds an account (by email) to a group. Returns nothing.
def group_add(client, options)
  if options[:group].nil? or options[:email].nil?
    puts "Missing arguments"
    return
  end

  group = client.groups.get options[:group]
  account = get_account(client, options)

  if account.nil? or group.nil?
    puts "Account or group not found"
    return
  end

  account.add_group group
  puts "Account added to group."
end  

# Send a password request to an email. Returns nothing.
def send_password_reset(client, options)
  if options[:application].nil? or options[:email].nil?
    puts "Missing arguments"
    return
  end

  # TODO: Add exception handling
  application = client.applications.get options[:application]
  application.send_password_reset_email options[:email]
  puts "Account password request sent."
end

# Finds an account by email. Internal method. Returns Account object.
def find_account(accounts, email)
  accounts.each do |acc|
    if acc.email == email
      return acc
    end
  end

  return nil
end

# List all application for a client. Returns nothing.
def list_applications(client)
  client.applications.each do |application|
    puts "Application: #{application.name}"
    puts "  Description: #{application.description}"
    puts "  Status: #{application.status}"
    puts "  Href: #{application.href}"
  end 
end

# Deletes an application. Returns nothing.
def delete_application(client, options)
  if !options[:application].nil?
    application = client.applications.get options[:application]
    application.delete
    puts "Application deleted."
    return
  else
    puts "Missing arguments"
    return
  end  
end

# List all directories for a client. Returns nothing.
def list_directories(client)
  client.directories.each do |directory|
    puts "Directory: #{directory.name}"
    puts "  Description: #{directory.description}"
    puts "  Status: #{directory.status}"
    puts "  Href: #{directory.href}"
  end
end

# Deletes a directory. Returns nothing.
def delete_directory(client, options)
  if !options[:directory].nil?
    directory = client.directories.get options[:directory]
    directory.delete
    puts "Directory deleted."
    return
  else
    puts "Missing arguments"
    return nil
  end
end

# List all groups in a directory. Returns nothing.
def list_groups(client, options)
  if !options[:directory].nil?
    directory = client.directories.get options[:directory]
    groups = directory.groups
  else
    puts "Missing arguments"
    return
  end

  groups.each do |group|
    print_group(group)
  end
end

# Deletes a group in a directory. Returns nothing.
def delete_group(client, options)
  if options[:directory].nil? or options[:group].nil?
    puts "Missing arguments"
    return
  end

  groups = client.groups
  group = groups.get options[:group]
  group.delete
  puts "Group deleted."
  return
end 


# Outputs the details of an account.
def print_account(account)
  puts "Email: #{account.email}"
  puts "Username: #{account.username}"
  puts "First name: #{account.given_name}"
  puts "Last name: #{account.surname}"
  puts "Status: #{account.status}"
end

# Outputs the details of a group.
def print_group(group)
  puts "Name: " + group.name
  puts "Description: " + (group.description.nil? ? "None" : group.description)
  puts "Status: " + group.status
  puts "Href: " + group.href
end

# Outputs the detaails of an error.
def print_error(error)
  puts "Message: " + error.message
  puts "HTTP Status: " + error.status.to_s
  puts "Developer Message: " + error.developer_message
  puts "More Information: " + error.more_info
  puts "Error Code: " + error.code.to_s
end


options = {}
client = myinitialize()
opt_parser = help(options)
opt_parser.parse!


case ARGV[0]
  when "account"
    case ARGV[1]
      when "list"
        list_accounts(client, options)
      when "create"
        create_account(client, options)
      when "update"
        update_account(client, options)
      when "authenticate"
        authenticate_account(client, options)
      when "delete"
        delete_account(client, options)
      when "find"
        get_account_and_display(client, options)
      when "group-add"
        group_add(client, options)
      when "send-password-reset"
        send_password_reset(client, options)
      else
        puts "Invalid account action"
    end
  when "application"
    case ARGV[1]
      when "list"
        list_applications(client)
      when "create"
        create_application(client, options)
      when "delete"
        delete_application(client, options)
      else
        puts "Invalid application action"
    end
  when "directory"
    case ARGV[1]
      when "list"
        list_directories(client)
      when "create"
        create_directory(client, options)
      when "delete"
        delete_directory(client, options)
      else
        puts "Invalid directory action"    
    end
  when "group"
    case ARGV[1]
      when "list"
        list_groups(client, options)
      when "create"
        create_group(client, options)
      when "delete"
        delete_group(client, options)
      else
        puts "Invalid group action"
    end
  else
    # Outputs the help for the command line utility.
    puts opt_parser
end

