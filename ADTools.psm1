#requires -version 4


# Load External functions.
. $PSScriptRoot\Convert-CanonicalNameToDistinguishedName.ps1
. $PSScriptRoot\Get-ADTrustedDomains.ps1
. $PSScriptRoot\Get-DomainControllers.ps1
. $PSScriptRoot\Get-SIDHistoryDomain.ps1
. $PSScriptRoot\Get-WindowsServers.ps1
. $PSScriptRoot\Split-ADDNPath.ps1
. $PSScriptRoot\Start-ADUserPoll.ps1
. $PSScriptRoot\Test-sAMAccountNameExists.ps1
. $PSScriptRoot\Test-UPNExists.ps1




function CapitalizeFirstLeter ([string] $Word)
{
<#
.DESCRIPTION
   This function capitalizes the first letter of the word (or group of words) 
   and sets all other characters to lower case.
.EXAMPLE
CapitalizeFirstLeter -Word "troubadour"

In this example, "Troubadour" would be returned.
.EXAMPLE
CapitalizeFirstLeter -Word "i Like cheese"

Note: The 'i' is lower case and the 'L' in 'Like' is upper case.)

In this example, "I like cheese" would be returned.
#>
    "$($word[0].ToString().ToUpper())$($Word.Substring(1).ToLower())"
}


function Get-SimplePassword
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$False,
                   Position=0)]
        $SymbolCount = 1
    )

    Begin
    {
$WordList = @"
aardvark
abyssinian
accelerator
accordion
account
accountant
acknowledgment
acoustic
acrylic
action
active
activity
actress
adapter
addition
address
adjustment
advantage
advertisement
advice
afghanistan
africa
aftermath
afternoon
aftershave
afterthought
agenda
agreement
airbus
airmail
airplane
airport
airship
albatross
alcohol
algebra
algeria
alligator
almanac
alphabet
aluminium
aluminum
ambulance
america
amount
amusement
anatomy
anethesiologist
angora
animal
answer
antarctica
anteater
antelope
anthony
anthropology
apartment
apology
apparatus
apparel
appeal
appendix
appliance
approval
aquarius
archaeology
archeology
archer
architecture
argentina
argument
arithmetic
armadillo
armchair
armenian
ashtray
asparagus
asphalt
asterisk
astronomy
athlete
attack
attempt
attention
attraction
august
australia
australian
author
authorisation
authority
authorization
avenue
babies
baboon
backbone
badger
bagpipe
bakery
balance
balinese
balloon
bamboo
banana
bandana
bangladesh
bangle
bankbook
banker
barbara
barber
baritone
barometer
baseball
basement
basket
basketball
bassoon
bathroom
bathtub
battery
battle
beautician
beauty
beaver
bedroom
beetle
beggar
beginner
begonia
behavior
belgian
belief
believe
bengal
bestseller
bibliography
bicycle
billboard
biology
biplane
birthday
bladder
blanket
blinker
blizzard
blouse
blowgun
bobcat
bonsai
bookcase
booklet
border
botany
bottle
bottom
boundary
bowling
bracket
branch
brandy
brazil
breakfast
breath
bridge
british
broccoli
brochure
broker
bronze
brother
brother-in-law
bubble
bucket
budget
buffer
buffet
building
bulldozer
bumper
burglar
business
butane
butcher
butter
button
buzzard
cabbage
cabinet
cactus
calculator
calculus
calendar
camera
canada
canadian
cancer
candle
cannon
canvas
capital
cappelletti
capricorn
captain
caption
caravan
carbon
cardboard
cardigan
carnation
carpenter
carriage
carrot
cartoon
castanet
catamaran
caterpillar
cathedral
catsup
cattle
cauliflower
caution
c-clamp
ceiling
celery
celeste
cellar
celsius
cement
cemetery
centimeter
century
ceramic
cereal
certification
chance
change
channel
character
charles
chauffeur
cheese
cheetah
chemistry
cheque
cherries
cherry
chicken
chicory
children
chimpanzee
chinese
chocolate
christmas
christopher
chronometer
church
cicada
cinema
circle
circulation
cirrus
citizenship
clarinet
client
clipper
cloakroom
closet
cloudy
clover
clutch
cobweb
cockroach
cocktail
coffee
collar
college
collision
colombia
colony
column
columnist
comfort
command
commission
committee
community
company
comparison
competition
competitor
composer
composition
computer
condition
condor
confirmation
conifer
connection
consonant
continent
control
cooking
copper
copyright
cormorant
cornet
correspondent
cotton
cougar
country
course
cousin
cowbell
cracker
craftsman
crawdad
crayfish
crayon
creator
creature
credit
creditor
cricket
criminal
crocodile
crocus
croissant
cucumber
cultivator
cupboard
cupcake
curler
currency
current
curtain
cushion
custard
customer
cuticle
cyclone
cylinder
cymbal
daffodil
dahlia
damage
dancer
danger
daniel
dashboard
database
daughter
deadline
deborah
debtor
decade
december
decimal
decision
decrease
dedication
defense
deficit
degree
delete
delivery
dentist
deodorant
department
deposit
description
desert
design
desire
dessert
destruction
detail
detective
development
diamond
diaphragm
dibble
dictionary
difference
digestion
digger
digital
dimple
dinghy
dinner
dinosaur
diploma
dipstick
direction
disadvantage
discovery
discussion
disease
disgust
distance
distribution
distributor
diving
division
doctor
dogsled
dollar
dolphin
domain
donald
donkey
dorothy
double
downtown
dragon
dragonfly
drawbridge
drawer
dredger
dresser
dressing
driver
driving
drizzle
duckling
dugout
dungeon
earthquake
editor
editorial
education
edward
effect
eggnog
eggplant
element
elephant
elizabeth
ellipse
employee
employer
encyclopedia
energy
engine
engineer
engineering
english
enquiry
entrance
environment
equinox
equipment
estimate
ethernet
ethiopia
euphonium
europe
evening
examination
example
exchange
exclamation
exhaust
ex-husband
existence
expansion
experience
expert
explanation
ex-wife
eyebrow
eyelash
eyeliner
facilities
factory
fahrenheit
fairies
family
farmer
father
father-in-law
faucet
feather
feature
february
fedelini
feedback
feeling
felony
female
fender
ferryboat
fertilizer
fiberglass
fiction
fighter
finger
fireman
fireplace
firewall
fisherman
flavor
flight
flower
flugelhorn
football
footnote
forecast
forehead
forest
forgery
format
fortnight
foundation
fountain
foxglove
fragrance
france
freckle
freeze
freezer
freighter
french
friction
friday
fridge
friend
furniture
galley
gallon
gander
garage
garden
garlic
gasoline
gateway
gazelle
gearshift
gemini
gender
geography
geology
geometry
george
geranium
german
germany
giraffe
girdle
gladiolus
glider
gliding
glockenspiel
goldfish
gondola
good-bye
gore-tex
gorilla
gosling
government
governor
granddaughter
grandfather
grandmother
grandson
graphic
grasshopper
grease
great-grandfather
great-grandmother
greece
grenade
ground
grouse
growth
guarantee
guatemalan
guilty
guitar
gymnast
hacksaw
haircut
half-brother
half-sister
halibut
hallway
hamburger
hammer
hamster
handball
handicap
handle
handsaw
harbor
hardboard
hardcover
hardhat
hardware
harmonica
harmony
headlight
headline
health
hearing
heaven
height
helicopter
helium
helmet
herring
hexagon
himalayan
hippopotamus
history
hobbies
hockey
holiday
hospital
hourglass
hovercraft
hubcap
humidity
hurricane
hyacinth
hydrant
hydrofoil
hydrogen
hygienic
icebreaker
icicle
ikebana
illegal
imprisonment
improvement
impulse
income
increase
indonesia
industry
innocent
insect
instruction
instrument
insulation
insurance
interactive
interest
internet
interviewer
intestine
invention
inventory
invoice
island
israel
italian
jacket
jaguar
january
japanese
jasmine
jellyfish
jennifer
jogging
joseph
journey
jumper
justice
kamikaze
kangaroo
karate
kenneth
ketchup
kettle
kettledrum
keyboard
keyboarding
kidney
kilogram
kilometer
kimberly
kitchen
kitten
knickers
knight
knowledge
kohlrabi
korean
laborer
ladybug
landmine
language
lasagna
latency
laundry
lawyer
learning
leather
lemonade
lentil
leopard
letter
lettuce
library
license
lightning
lipstick
liquid
liquor
literature
litter
lizard
lobster
locket
locust
lotion
lumber
lunchroom
luttuce
lyocell
macaroni
machine
macrame
magazine
magician
mailbox
mailman
makeup
malaysia
mallet
manager
mandolin
manicure
maraca
marble
margaret
margin
marimba
market
mascara
mattock
mayonnaise
measure
mechanic
medicine
meeting
melody
memory
mercury
message
meteorology
methane
mexican
mexico
michael
michelle
microwave
middle
milkshake
millennium
millimeter
millisecond
mimosa
minibus
mini-skirt
minister
minute
mirror
missile
mistake
mitten
monday
monkey
morning
morocco
mosque
mosquito
mother
mother-in-law
motion
motorboat
motorcycle
mountain
moustache
multi-hop
multimedia
muscle
museum
musician
mustard
myanmar
napkin
narcissus
nation
needle
nephew
network
newsprint
newsstand
nickel
nigeria
nitrogen
noodle
norwegian
notebook
notify
november
number
numeric
oatmeal
objective
observation
occupation
ocelot
octagon
octave
october
octopus
odometer
offence
office
operation
ophthalmologist
opinion
option
orange
orchestra
orchid
organisation
organization
ornament
ostrich
output
outrigger
overcoat
oxygen
oyster
package
packet
pajama
pakistan
pamphlet
pancake
pancreas
panther
panties
pantry
pantyhose
paperback
parade
parallelogram
parcel
parent
parentheses
parrot
parsnip
particle
partner
partridge
passbook
passenger
passive
pastor
pastry
patient
patricia
payment
peanut
pedestrian
pediatrician
peer-to-peer
pelican
penalty
pencil
pendulum
pentagon
pepper
perfume
period
periodical
peripheral
permission
persian
person
pharmacist
pheasant
philippines
philosophy
physician
piccolo
pickle
picture
pigeon
pillow
pimple
pisces
planet
plantation
plaster
plasterboard
plastic
platinum
playground
playroom
pleasure
plough
plywood
pocket
poison
poland
police
policeman
polish
politician
pollution
polyester
popcorn
population
porcupine
porter
position
possibility
postage
postbox
potato
poultry
powder
precipitation
preface
pressure
priest
printer
prison
probation
process
processing
produce
product
production
professor
profit
promotion
propane
property
prosecution
protest
protocol
pruner
psychiatrist
psychology
ptarmigan
puffin
pumpkin
punishment
purchase
purple
purpose
pyjama
pyramid
quality
quarter
quartz
question
quicksand
quince
quiver
quotation
rabbit
racing
radiator
radish
railway
rainbow
raincoat
rainstorm
random
ravioli
reaction
reading
reason
receipt
recess
record
recorder
rectangle
reduction
refrigerator
refund
regret
reindeer
relation
relative
religion
relish
reminder
repair
replace
report
representative
request
resolution
respect
responsibility
restaurant
result
retailer
revolve
revolver
reward
rhinoceros
rhythm
richard
riddle
riverbed
roadway
robert
rocket
romania
romanian
ronald
rooster
rotate
router
rowboat
rubber
russia
russian
rutabaga
sagittarius
sailboat
sailor
salary
salesman
salmon
sampan
samurai
sandra
sandwich
sardine
saturday
sausage
saxophone
scallion
scanner
scarecrow
schedule
school
science
scissors
scooter
scorpio
scorpion
scraper
screen
screwdriver
seagull
seaplane
search
seashore
season
second
secretary
secure
security
seeder
segment
select
selection
semicircle
semicolon
sentence
september
servant
server
session
shadow
shallot
shampoo
sharon
shears
shield
shingle
shoemaker
shorts
shoulder
shovel
shrimp
shrine
siamese
siberian
sideboard
sidecar
sidewalk
signature
silica
silver
singer
single
sister
sister-in-law
skiing
slipper
sneeze
snowboarding
snowflake
snowman
snowplow
snowstorm
soccer
society
sociology
softball
softdrink
software
soldier
soprano
sousaphone
soybean
spaghetti
spandex
sparrow
specialist
speedboat
sphere
sphynx
spider
spinach
spleen
sponge
spring
sprout
spruce
square
squash
squirrel
staircase
starter
statement
station
statistic
step-aunt
step-brother
stepdaughter
step-daughter
step-father
step-grandfather
step-grandmother
stepmother
step-mother
step-sister
stepson
step-son
step-uncle
steven
stinger
stitch
stocking
stomach
stopsign
stopwatch
stranger
stream
street
streetcar
stretch
string
structure
sturgeon
submarine
substance
subway
success
suggestion
summer
sunday
sundial
sunflower
sunshine
supermarket
supply
support
surfboard
surgeon
surname
surprise
swallow
sweater
sweatshirt
sweatshop
swedish
sweets
swimming
switch
swordfish
sycamore
system
tablecloth
tabletop
tachometer
tadpole
tailor
taiwan
tanker
tanzania
target
taurus
taxicab
teacher
teaching
technician
television
teller
temper
temperature
temple
tendency
tennis
territory
textbook
texture
thailand
theater
theory
thermometer
thistle
thomas
thought
thread
thrill
throat
throne
thunder
thunderstorm
thursday
ticket
tights
timbale
timpani
titanium
toenail
tomato
tom-tom
toothbrush
toothpaste
tornado
tortellini
tortoise
tractor
traffic
transaction
transmission
transport
trapezoid
treatment
triangle
trigonometry
trombone
trouble
trousers
trowel
trumpet
t-shirt
tuesday
tugboat
turkey
turkish
turnip
turnover
turret
turtle
twilight
typhoon
uganda
ukraine
ukrainian
umbrella
undershirt
utensil
uzbekistan
vacation
vacuum
valley
vegetable
vegetarian
velvet
venezuela
venezuelan
verdict
vermicelli
vessel
veterinarian
vibraphone
vietnam
violet
violin
viscose
vision
visitor
volcano
volleyball
voyage
vulture
waiter
waitress
wallaby
wallet
walrus
washer
watchmaker
waterfall
wealth
weapon
weasel
weather
wednesday
weeder
weight
whiskey
whistle
wholesaler
wilderness
william
willow
windchime
window
windscreen
windshield
winter
withdrawal
witness
woolen
workshop
wrecker
wrench
wrinkle
writer
xylophone
yellow
yogurt
yugoslavian
zephyr
zipper
zoology
"@

    $WordArray = $WordList -split "`n"
    }

    Process
    {
        $Wordcount = 1

        [array]$Words = $WordArray | get-random -Count $Wordcount

        for ($i = 0; $i -lt $Words.count; $i++)
        { 
            $Words[$i] = CapitalizeFirstLeter -Word $Words[$i]
        }

        $number = get-random -Minimum 1000 -Maximum 9999

        $symbolList = "!@#%^*_+-?"
        $symbolArray = $symbolList.ToCharArray()

        $Symbols = "$($symbolArray | get-random -Count $SymbolCount)".replace(' ','')

        $format = 1,2,3,4 | get-random
        switch (1,2,3,4 | get-random)
        {
            1
            {
                $PWString = "$($Words[0])$Symbols$($Words[1])$number"
                Break
            }
            2
            {
                $PWString = "$($Words[0])$Symbols$number$($Words[1])"
                Break
            }
            3
            {
                $PWString = "$Symbols$($Words[0])$($Words[1])$number"
                Break
            }
            4
            {
                $PWString = "$number$($Words[0])$Symbols$($Words[1])"
                
                Break
            }
            Default
            {
            }
        }
        $pwstring.remove($pwstring.IndexOf([char]13),1)
    }

    End
    {
    }
}


function Set-PasswordGUI
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Param1
    )

    function GetSetPasswordCommand ($UserID, $Password, $Server)
    {
        if ([string]::IsNullOrEmpty($Password))
        {
            $Password = "<Password>"
        }
        
        if ([string]::IsNullOrEmpty($UserID))
        {
            $UserID = "<UserID>"
        }
        else
        {
            $UserID = "'$UserID'"
        }

        if ([string]::IsNullOrEmpty($Server))
        {
            $Server = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
        }

        if ([string]::IsNullOrEmpty($UserID) -or[string]::IsNullOrEmpty($Password) )
        {
            $tbx_PowerShellcommand.Background = "Red"
        }
        else
        {
            $tbx_PowerShellcommand.Background = "white"
        }

        "Set-ADAccountPassword -Identity $UserID -Reset -NewPassword `$`(ConvertTo-SecureString -AsPlainText '$Password' -Force`) -Server $Server"
    }

    [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml] $XAMLform = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Password Reset" Height="450" Width="538">
    <Grid Margin="0,0,0,22.8">
        <Label x:Name="lbl_SpecialCharacters" Content="# of special Characters:" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top"/>
        <Button x:Name="btn_Generate" Content="Generate" HorizontalAlignment="Left" Margin="216,13,0,0" VerticalAlignment="Top" Width="75"/>
        <TextBox x:Name="tbx_Password" HorizontalAlignment="Left" Height="25" Margin="145,41,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="230"/>
        <Label x:Name="lbl_Password" Content="Password:" HorizontalAlignment="Left" Margin="10,41,0,0" VerticalAlignment="Top" Width="130"/>
        <Label x:Name="lbl_Username" Content="UserName:" HorizontalAlignment="Left" Margin="10,98,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="tbx_Username" HorizontalAlignment="Left" Height="23" Margin="145,98,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="230"/>
        <Button x:Name="btn_Search" Content="Search" HorizontalAlignment="Left" Margin="409,101,0,0" VerticalAlignment="Top" Width="75"/>
        <ListBox x:Name="tbx_SearchResults" HorizontalAlignment="Left" Height="73" Margin="145,136,0,0" VerticalAlignment="Top" Width="363"/>

        <TextBox x:Name="tbx_PowerShellcommand" HorizontalAlignment="Left" Height="100" Margin="145,234,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="363" IsReadOnly="True"/>

        <Label x:Name="lbl_PowerShell" Content="PowerShell:" HorizontalAlignment="Left" Margin="10,234,0,0" VerticalAlignment="Top" Width="122"/>
        <Button x:Name="btn_SetPassword" Content="Set Password" HorizontalAlignment="Left" Margin="350,350,0,0" VerticalAlignment="Top" Width="75"/>
        <TextBox x:Name="tbx_SpecialCharacters" HorizontalAlignment="Left" Height="23" Margin="146,10,0,0" TextWrapping="Wrap" Text="2" VerticalAlignment="Top" Width="53" TextAlignment="Right"/>
        <Button x:Name="btn_Cancel" Content="Cancel" HorizontalAlignment="Left" Margin="430,350,0,0" VerticalAlignment="Top" Width="75"/>
        <Label x:Name="lbl_Version" Content="v0.1" HorizontalAlignment="Left" Margin="490,0,0,0" VerticalAlignment="Top"/>

    </Grid>
</Window>
'@

        #<Label x:Name="lbl_PowerShellcommand" Content="Set-ADPassword" HorizontalAlignment="Left" Margin="145,234,0,0" VerticalAlignment="Top" Width="363"/>
        #<ListBox x:Name="tbx_PowerShellcommand" HorizontalAlignment="Left" Height="73" Margin="145,136,0,0" VerticalAlignment="Top" Width="363"/>


    $reader=(New-Object System.Xml.XmlNodeReader $XAMLform)
    $Form=[Windows.Markup.XamlReader]::Load( $reader )


    # tbx_Password
    $tbx_Password = $Form.findName("tbx_Password")

    # tbx_Username
    $tbx_Username = $Form.findName("tbx_Username")

    # tbx_SearchResults
    $tbx_SearchResults = $Form.findName("tbx_SearchResults")

    # tbx_SpecialCharacters
    $tbx_SpecialCharacters = $Form.findName("tbx_SpecialCharacters")

    # btn_Search
    $btn_Search = $Form.findName("btn_Search")

    # btn_Generate
    $btn_Generate = $Form.findName("btn_Generate")

    # btn_SetPassword
    $btn_SetPassword = $Form.findName("btn_SetPassword")

    # btn_Cancel
    $btn_Cancel = $Form.findName("btn_Cancel")

    # tbx_PowerShellcommand
    $tbx_PowerShellcommand = $Form.findName("tbx_PowerShellcommand")

    # Cancel button
    $btn_Cancel.Add_Click({
        $Form.Close()
    })

    # Generate button
    $btn_Generate.Add_Click({
        #$tbx_Password | gm |ft * -auto -force | out-string -stream | % {write-host -fore yellow "$_"}
        #$tbx_SearchResults | gm |ft * -auto -force | out-string -stream | % {write-host -fore yellow "$_"}
        [string] $PasswordString = "$(Get-SimplePassword -SymbolCount $($tbx_SpecialCharacters.text))"
        $PasswordString = $PasswordString.remove($PasswordString.IndexOf([char]13),1)
        $tbx_Password.Text = $PasswordString 
        write-host -fore yellow "Password generated: $PasswordString"
        $tbx_PowerShellcommand.Text = GetSetPasswordCommand -UserID $($tbx_SearchResults.SelectedItem) -Password $PasswordString
    })

    # Find User
    $btn_Search.Add_Click({
        $SearchText = $tbx_Username.Text
        if ([string]::IsNullOrEmpty($SearchText))
        {
            $tbx_Username.Text = "Username"
            return
        }
        else
        {
            $found = Get-ADObject -LDAPFilter "(|(anr=$SearchText))" -server ([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name)
        }
        
        #$tbx_SearchResults.BeginUpdate()
        $tbx_SearchResults.Items.Clear()
        foreach ($entry in $Found)
        {
            $tbx_SearchResults.Items.Add($($entry.distinguishedName))
        }
        # $tbx_SearchResults.Items[0] | gm |ft * -auto -force | out-string -stream | % {write-host -fore yellow "$_"}


    })

    $tbx_SearchResults.Add_SelectionChanged({
        $tbx_PowerShellcommand.Text = GetSetPasswordCommand -UserID $($tbx_SearchResults.SelectedItem) -Password $($tbx_Password.Text)
    })


    $result = $Form.ShowDialog()
}


function Add-GroupMembershipGUI
{
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
    $TrustedDomains = Get-ADTrustedDomains

    [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml] $XAMLform = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Default Groups" Height="350" Width="525">
    <Grid>
        <Label x:Name="lbl_domain" Content="Domain" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="107"/>
        <ComboBox x:Name="cbx_domain" HorizontalAlignment="Left" Margin="122,13,0,0" VerticalAlignment="Top" Width="251"/>
        <RadioButton x:Name="rbn_NewUser" Content="New User" HorizontalAlignment="Left" Margin="122,184,0,0" VerticalAlignment="Top" GroupName="DefaultGroups"/>
        <Button x:Name  ="btn_OK" Content="OK" HorizontalAlignment="Left" Margin="433,292,0,0" VerticalAlignment="Top" Width="75"/>
        <Button x:Name  ="btn_Cancel" Content="Cancel" HorizontalAlignment="Left" Margin="351,292,0,0" VerticalAlignment="Top" Width="75"/>
        <Label x:Name   ="lbl_PowerShellCommand" Content="Set-ADPassword" HorizontalAlignment="Left" Margin="122,253,0,0" VerticalAlignment="Top" Width="386"/>
        <Label x:Name   ="lbl_PowerShell" Content="PowerShell:" HorizontalAlignment="Left" Margin="10,253,0,0" VerticalAlignment="Top" Width="122"/>
        <Label x:Name   ="lbl_Username" Content="UserName:" HorizontalAlignment="Left" Margin="10,53,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name ="tbx_Username" HorizontalAlignment="Left" Height="23" Margin="122,53,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="251"/>
        <Button x:Name  ="btn_Search" Content="Search" HorizontalAlignment="Left" Margin="410,56,0,0" VerticalAlignment="Top" Width="75"/>
        <ListBox x:Name ="tbx_SearchResults" HorizontalAlignment="Left" Height="73" Margin="122,91,0,0" VerticalAlignment="Top" Width="363"/>

    </Grid>
</Window>
'@

    $reader=(New-Object System.Xml.XmlNodeReader $XAMLform)
    $Form=[Windows.Markup.XamlReader]::Load( $reader )

    #
    #    Domain
    #

    $cbx_domain = $Form.findName("cbx_domain")

    $cbx_domain.Items.Add([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name) | out-null
    $cbx_domain.SelectedIndex = 0

    foreach ($Trusteddomain in $TrustedDomains)
    {
        $cbx_domain.Items.Add($Trusteddomain.cn) | out-null
    }


    #
    #    User Search
    #

    # tbx_Username
    $tbx_Username = $Form.findName("tbx_Username")

    # tbx_SearchResults
    $tbx_SearchResults = $Form.findName("tbx_SearchResults")

    # btn_Search
    $btn_Search = $Form.findName("btn_Search")



    #
    #   bottom buttons
    #

    # btn_Cancel
    $btn_Cancel = $Form.findName("btn_Cancel")

    # tbx_PowerShellcommand
    $tbx_PowerShellcommand = $Form.findName("tbx_PowerShellcommand")


    # Cancel button
    $btn_Cancel.Add_Click({
        $Form.Close()
    })

    # Find User
    $btn_Search.Add_Click({
        $SearchText = $tbx_Username.Text
        if ([string]::IsNullOrEmpty($SearchText))
        {
            $tbx_Username.Text = "Username"
            return
        }
        else
        {
            $found = Get-ADObject -LDAPFilter "(|(anr=$SearchText))" -server $($cbx_domain.Items[$cbx_domain.SelectedIndex])
        }

        #$tbx_SearchResults.BeginUpdate()
        $tbx_SearchResults.Items.Clear()
        foreach ($entry in $Found)
        {
            $tbx_SearchResults.Items.Add($($entry.distinguishedName))
        }
        $tbx_SearchResults.Items[0] | gm |ft * -auto -force | out-string -stream | % {write-host -fore yellow "$_"}


    })

    $result = $Form.ShowDialog()


}










