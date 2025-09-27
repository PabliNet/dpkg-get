# dpkg-get

dpkg-get is a simple yet powerful shell script for managing and viewing package status on Debian-based systems (like Debian, Ubuntu, and their derivatives). It uses dpkg \--get-selections and awk to provide a clear and colored overview of installed, held, and deinstalled packages.

## Features

* **Colored Output**: Packages are displayed with colors for better readability:  
  * **Green**: install  
  * **Blue**: hold  
  * **Red**: deinstall  
* **Multiple Options**: Filter and show only packages of interest (installed, held, deinstalled).  
* **Package Management**: Includes an option to automatically purge deinstalled packages.  
* **Multi-language Support**: Help and error messages are available in both English and Spanish.

## Usage

To use the script, simply download it and make it executable:

chmod \+x dpkg-get.sh

### Options

Run the script without any arguments to see all installed, held, and deinstalled packages with a summary at the end.

./dpkg-get.sh

**Status Filters:**

* **\-i**: Shows only **installed** packages. Packages on hold are marked with an asterisk (\*).  
* **\-h**: Lists only packages in the **hold** state.  
* **\-d**: Lists only packages in the **deinstall** state (removed but not purged).
* **-H:** Do not list packages on **hold**. This option filters the default output to show only install and deinstall packages, excluding those in hold.

**Quiet Output:**

Add the \-q option to any filter (-iq, \-hq, \-dq) for a "quiet" output that only shows the package names without totals or headers.

**Summary:**

* **\-s**: Displays a summary of the counts of installed, held, and deinstalled packages.

**Help:**

* \--help: Displays the detailed script help.

**Special Actions:**

* autopurge: Automatically **purges** all packages that are in the deinstall state. This **requires root permissions**.

sudo ./dpkg-get.sh autopurge

## Example Output

Here is an example of the default script output:

STATUS    → PACKAGES  
install   → package-a  
install   → package-b  
install   → package-c  
hold      → package-d  
deinstall → package-e  
deinstall → package-f  
installs: 3 (1 holds) deinstalls: 2

