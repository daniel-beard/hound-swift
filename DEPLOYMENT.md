# Deployment

This section will describe how the server is set up and deployed.

## Machine Setup

Our server is hosted with https://macstadium.com/

Once the server is set up, follow these steps.

1. VNC in and install the latest Xcode. 
   Make sure to open it so you can accept the license and TOS.
2. Run the server setup script
   `curl -fsS 'https://raw.githubusercontent.com/thoughtbot/hound-swift/master/bin/server-setup' | bash`
3. `cd` into `~/hound-swift`.
4. Set the environment variables in `.env`.
5. Start up the service with `foreman start`.

## Deploying a new version

1. VNC or SSH in and `cd ~/hound-swift && git pull origin master`
