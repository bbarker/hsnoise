module Main where

import Numeric.Noise.Ridged

import Codec.PPM.Binary
import Data.Word (Word8)

main = do
    -- The size of the resulting image.
    let size = 200

    -- Parameters for the noise function.
    let seed = 1
    let octaves = 5
    let scale = 0.05
    let frequency = 1
    let lacunarity = 2

    -- Create the ridged multi-fractal function.
    let ridgedNoise = ridged seed octaves scale frequency lacunarity 

    -- Compute the noise value for each pixel in the image.
    let coords = [1.0..fromInteger size]
    let xs = [noiseValue ridgedNoise (x, y, 0) | y <- coords, x <- coords]

    putStrLn (show (maximum xs))
    putStrLn (show (minimum xs))
    
    -- Convert the noise values to grayscale colors.
    let ps = map noiseToColor xs
    
    -- Write the image.
    writePPM "Noise.ppm" (size, size) ps
    return ()

-- Converts a value from -1 to 1 to a gray 24-bit color value from 0 to 255.
noiseToColor :: Double -> (Word8, Word8, Word8)
noiseToColor n = (n', n', n')
    where n' = fromInteger (floor ((n * 0.5 + 0.5) * 255)) :: Word8
