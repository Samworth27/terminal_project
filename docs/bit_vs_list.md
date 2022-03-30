To store symptoms as an array of codes or using bit flags

Using ICPC (International Classification of Primary Care) there are currently a maximum of 3200 different codes that can be used to describe a patient. However much less than that are actually used (approx 650)

To create a bit for each item would be 3200 bits or 400 bytes long. The ICPC uses a 4 digit code to identify symptoms or diagnosis. at 4 bytes per code for a total of 32 bits then using any more than 100 codes per item would mean the bit method becomes more effiecient.

It would also be possible to reduce the size of the 4 byte code using binary encoding. It is displayed in the format of
'Character Character Digit Digit'

The first character is used to represent one of 16 catagories. This can be stored using 4 bits.
The second character is either a 'S' for symptom or 'D' for diagnosis. This can be stored in 1 bit.
The last two bytes are integers which can also be displayed using 4 bits each thought of as a two digit integer between 0-99 and stored using 7 bits.
This means the 32 bits used to store the code can be reduced to 12 bits. However would require extra coding and decoding to store. Comparing this against the 3200 bit binary system would mean you could store 267 codes per patient before the bit method was more efficient
Because of how ruby stores numbers, if common symptoms where given lower flag values then the average storage size would be lower.
Using a string to store a character would mean that for one code you could store 32 symptoms using bits. So if the number of symptoms stored in the system is low it is more effecient when more symptoms are inputted.
eg someone present with a few symptoms being generally being sick
AS06 - Feeling ill
DS01 - General abdominal pain
DS09 - Nausea
DS10 - Vomiting
DS11 - Diarrhoea
5 codes being entered is 160 bits, or 160 different symptoms being entered

Which method to be used can be though as use bit flags if (average_number_options*bits_to_store_code) > number_of_options

There are other things to consider including a comparison of max record size 3200 bits (0.4 Kilobytes) vs 102,400 bits (12.8 Kilobytes)

As a bit method had already been created before considering this I will continue to use it

Final count on IDs is approx 1500, which is ~47 codes. Given these codes include information such as reasons for visits, symptoms, diagnosis, function evaluations and more it is plausible that one may end up with more than 47 codes.
Because ruby will drop leading bits from storage and the most common codes have lower values the average size of the bit method will be lower than 1500.
Further on a system to allow the symptom database to reorder its keys based on the amount they are used would amplfy this effect