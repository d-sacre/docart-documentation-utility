# docART: A Utility to facilitate writing documentations with LaTeX
A Python/Lua(LaTeX) Utility and LATEX Class for Semi-automated Documentation of Projects involving Hardware and/or Software.

The docART Utility can be useful for:
- Prototype development (Hard- and Software),
- Software Development Kit (SDK) documentation,
- User manuals/command reference for machines and scientific equipment,
- Penetration testing documentation.

The docART Utility provides (wrapper) macros and routines to facilitate/automate tedious LaTeX tasks like figures, tables and listings. Besides that, it provides additional components for structuring the document, highlighting of important content and references to objects. The main focus is on allowing the inclusion of up-to-date source code. For creating tutorials, there is the possiblilty to use docART listing commments in the source code to tell the docART Utility which part of the file should be included at which point in time. And if the source code changes, the docART Utility will include the newest version into the documentation the next time you run it.

## Important Note
The docART Utility uses shell escape to provide its functionality. Please check BEFORE installation whether this complies with your IT Security Policy.

## Installation
1. Install a pdf reader,
2. Install Python 3,
3. Install a LaTeX Backend (MikTeX, texlive, ...),
4. Install optional components (e. g. LaTeX IDE like TeXstudio),
5. Download and unpack the docART Utility's github repository,
6. Verify the installation by compiling `docart_mwe.tex`.

## Configuration
- docART: Rename `docart_mwe.tex` to whatever you like.
- Terminal/command line: Nothing to do.
- TeXstudio: Enable shell escape for lualatex.

## Usage
1. Write your docART/LaTeX code in `PATH/TO/FILENAME.tex`,
2. Create your pdf: 
   - Terminal/command line:
       1. Change into the correct directory: `cd PATH/TO/`
       2. Run `lualatex --shell-escape FILENAME.tex`.
   - TeXstudio: Press `F5`.
3. Check/inspect your pdf (external pdf viewer or internal pdf viewer of TeXstudio),
4. Repeat step 1 to step 3 until you are satisfied with the content of your document.
   
## Documentation
- Handbook: `./docart-utility/documentation/docart_handbook_alpha-2022-04-30_rev0.pdf`,
- Quickstart & Reference: To be written.

## Copyright Information
Copyright (C) 2022 Martin Stimpfl, Daniel Sacré

The docART Utility is released under GNU General Public License (GPLv3). 

DISCLAIMER:<br>
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.