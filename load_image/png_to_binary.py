from PIL import Image
def rgb_of_pixel(im, x, y):
    r, g, b = im.getpixel((x, y))
    a = (r, g, b)
    return a

def getPaletteIndex(palette,r,g,b):
    ind =0
    for i in palette:
        if i[0]==r and i[1]==g and i[2]==b:
            return ind
        ind += 1
    newentry = [ r,g,b ]
    palette.append(newentry)
    return len(palette)-1

image = "image_320x200x256.png"
im = Image.open(image).convert('RGB')

imagePixels = []
mt = []
palette = []
for e in range(200):
    for i in range(320):
        r,g,b = rgb_of_pixel(im,i,e)
        mt.append(getPaletteIndex(palette,r,g,b))
    imagePixels.append(mt)
    mt=[]


newFile = open("image.bin", "wb")
newFileBytes = []
num = 0   

for y in range(200):
    for x in range(320):
        newFileBytes.append(imagePixels[y][x])
        num += 1

for i in palette:
    newFileBytes.append(i[0])
    newFileBytes.append(i[1])
    newFileBytes.append(i[2])
    num += 3

for i in range(256):
    newFileBytes.append(0)
    num += 1

print(num,"Bytes")
newFileByteArray = bytearray(newFileBytes)
newFile.write(newFileByteArray)

