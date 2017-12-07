import           Control.Monad.Primitive     (PrimMonad, PrimState)
import qualified Data.Vector.Unboxed         as V
import qualified Data.Vector.Unboxed.Mutable as M
import           System.Random               (StdGen, getStdGen, randomR)

input :: [Int]
input = [0, 1, 0, 0, 1, -3, 0, 0, 2, -2, -6, -3, 2, -5, -6, -3, -3, 0, -8, -12, 1, -9, -12, -9, 0, -7, -17, -6, -18, -7, -6, -21, -28, -14, -23, -14, -17, -5, -35, -17, -26, -14, 1, -27, -19, -40, -32, -44, 2, -14, -15, -12, -35, 0, -49, -12, -7, -46, -47, -32, -33, -47, -7, -62, -20, -35, -4, -35, -8, -3, -61, -38, -63, -27, -33, -57, -48, -66, -68, -11, -61, -50, -34, -31, -36, -79, -49, -71, 1, -34, -65, -61, -91, -12, -21, -82, -85, -51, -89, 0, -83, -53, -44, -7, 1, -19, -39, -27, -94, -36, -31, -35, -97, -45, -90, -15, -106, -30, -79, -18, -25, -105, -30, -63, -109, -32, -91, -96, -87, -121, -116, -103, -71, -1, -113, -10, -47, -109, -107, -38, -66, -26, -8, -38, -31, -129, -42, -91, -89, -107, -125, -75, -118, -81, -45, -111, -27, -63, -106, -110, -64, -63, -80, -44, -33, -130, -55, -90, -144, -15, -132, -122, -155, -122, -94, -159, -5, -89, -6, -97, -129, -159, -15, -44, -156, -124, -113, -154, -95, -96, -29, -121, -30, -73, -118, -57, -76, -141, -138, -108, -185, -56, -136, -161, -138, -192, 2, -126, -12, -39, -60, -125, -149, -193, -146, -116, -101, -16, -207, -122, -92, -204, -42, -112, -28, -93, -96, -57, -136, -19, -36, -107, -170, -19, -20, -96, -229, -59, -172, -58, -89, -31, -57, -223, -37, -189, -43, -135, -90, -150, -22, -152, -243, -37, -231, -112, -57, -168, -30, -77, -162, -181, -176, -202, -138, -206, -183, -190, -257, -181, -47, -23, -248, -114, -98, -77, -143, -168, -166, -30, -155, -237, -51, -113, -243, -41, -142, -231, -139, -20, -190, -262, -142, -238, -200, -270, -113, -35, -296, -146, -205, -129, -198, -68, -139, -56, -196, -133, -16, -229, -258, -91, -63, -249, -274, -156, -273, -182, -166, -115, -154, -296, -115, -89, -120, -201, -44, -287, -8, 1, -260, -297, -282, -114, -323, -326, -166, -241, -109, -21, -236, -280, -19, -80, -77, -271, -292, -340, -300, -206, -308, -99, -156, -277, -245, -132, -56, -172, -53, -271, -32, -5, -235, -329, -1, -150, -247, -268, -133, -341, -221, -2, -43, -229, -190, -337, -40, -71, -72, -149, -25, -253, -44, -113, -164, -370, -284, -235, -9, -234, -291, 1, -152, -302, -393, -47, -289, -75, -140, -349, -140, -353, -298, -27, -292, -380, -55, -62, -208, -221, -41, -316, -411, -367, -220, -248, -59, -177, -372, -55, -241, -240, -140, -315, -297, -42, -118, -141, -70, -183, -153, -30, -63, -306, -110, -8, -356, -80, -314, -323, -41, -176, -165, -41, -230, -132, -222, -2, -404, -38, -130, 2, -16, -141, -136, -336, -245, -6, -348, -172, -267, -208, -291, -285, -67, -219, -216, -136, -325, -27, -382, -242, -50, -284, -149, -454, -336, -346, -293, -402, -76, -324, -219, -336, -24, -446, -123, -185, -196, -295, -173, -400, -137, -414, -14, -104, -62, -252, -17, -398, -490, -440, -89, -347, -101, -142, -228, -301, -396, -320, -52, -508, -122, -436, -311, -344, -240, -434, -220, -197, -31, -295, -44, -452, -269, -430, -373, -409, -438, -365, -13, -241, -418, -20, -24, -141, -1, -148, -307, -63, -423, -254, -8, -438, -326, -19, -135, -109, -394, 2, -398, -273, -158, -453, -346, -86, -431, -536, -549, -379, -483, -85, -476, -483, -104, -87, -462, -249, -540, -164, -360, -100, -238, -45, -390, -59, -156, -248, -257, -150, -164, -160, -545, -520, -364, -384, -237, -456, -28, -366, -147, 0, -303, -583, -420, -370, -299, -154, -380, -188, -491, -258, -598, -429, -349, -333, -569, -4, -556, -421, -182, -441, -407, -542, -364, -370, -384, 1, -529, -45, -319, -395, -279, -160, -575, -193, -25, -565, -548, -445, -266, -304, -361, -348, -303, -159, -39, -75, -437, -608, -622, -556, -108, -343, -283, -68, -632, -393, -68, -140, -126, -531, -87, -519, -334, -56, -70, -275, -247, -370, -439, -118, -497, -630, -594, -612, -541, -161, -646, -397, -100, -284, -313, 0, -59, -200, -601, -663, -529, -676, -610, -7, -228, -50, -494, -382, -250, -306, -274, -163, -110, -375, -124, -237, -98, -645, -692, -495, -593, -647, -178, -531, -336, -697, -646, -671, -633, -542, -461, -200, -658, -525, -389, -643, -258, -329, -656, -400, -692, -557, -506, -594, -67, -623, -113, -459, -211, -713, -115, -602, -131, -181, -30, -227, -53, -719, -631, -641, -434, -552, -716, -368, -19, -439, -443, -552, -85, -79, -449, -254, -620, -474, -121, -210, -285, -608, -456, -513, -496, -13, -418, -399, -437, -258, -15, -623, -178, -336, -379, -721, -299, -729, -742, -64, -13, -438, -603, -666, -278, -767, -200, -686, -497, -256, -541, -491, -360, -615, -326, -682, -759, -524, -580, -323, -578, -793, -478, -107, -440, -657, -790, -605, -21, -163, -392, -560, -336, -430, -613, -182, -15, -782, -607, -281, -269, -25, -699, -89, -593, -280, -269, -438, -103, -359, -387, -157, -747, -619, -176, -772, -500, -735, -691, -797, -612, -573, -36, -617, -630, -357, -718, -210, -48, -185, -20, -556, -206, -722, -559, -416, -578, -745, -564, -273, -62, -300, -218, -711, -744, -805, -277, -522, -346, -280, -762, -438, -381, -379, -198, -737, -555, -466, -218, -511, -334, -353, -259, -225, -675, -350, -585, -647, -52, -395, -324, -106, -826, -279, -81, -396, -611, -312, -529, -291, -129, -594, -437, -188, -649, -820, -237, -673, -6, -387, -195, -503, -350, -83, -88, -626, -30, -313, -13, -633, -403, -319, -832, -185, -146, -839, -9, -557, -799, -841, -700, -465, -669, -769, -235, -849, -863, -819, -76, -912, -931, -909, -762, -607, -522, -64, -769, -377, -133, -414, -772, -206, -746, -730, -393, -901, -72, -33, -811, -372, -298, -835, -637, -302, -481, -958, -878, -867, -25, -260, -448, -21, -930, -903, -581, -547, -664, -843, -140, -337, -383, -513, -368, -221, -474, -169, -673, -728, -266, -862, -753, -815, -647, -106, -15, -728, -912, -147, -828, -6, -694, -434, -737, -335, -183, -732, -841, -364, -155, -116, -966, -822, -65, -22, -853, -208, -326, -826, -472, -491, -436, -771, -1009, -98, -401, -915, -275, -574, -313, -884, -648, -935, -94, -326, -553, -744, -723, -782, -719, -175, -868, -190, -153, -48, -218, -414, -721, -715, -995, -991, -575, -264, -70, -366, -381, -130, -409, -817, -258, -1028, -552, -878, -449, -138, -900, -45, -119, -677, -844, -869, -985, -1019, -60, -649, -915, -93, -1053, -121, -631, -156, -332, -193] 

-- steps pos memory
--t = (0, 0, [0,3,0,1,-3])

--step (n, p, xs) = (n + 1, p + o, take p xs ++ [(xs!!p)+1] ++ drop (p + 1) xs)
--  where o = xs!!p
--
--solve inp = steps $ until out step (0, 0, inp)
--  where steps (n, _, _) = n
--        out (_, p, _) = p < 0 || p >= length inp
--


-- steps pos memory
t :: [Int]
t = [0,3,0,1,-3]

step (n, p, xs) = (n + 1, p + o, V.take p xs V.++ (V.fromList [(xs V.! p)+inc]) V.++ V.drop (p + 1) xs)
  where o = xs V.! p
        inc :: Int
        inc = if o >= 3 then (-1) else 1

--solve inp = steps $ until out step (0, 0, inp)
--  where steps (n, _, _) = n
--        out (_, p, _) = p < 0 || p >= V.length inp

--main = do 
--  print $ solve $ V.fromList input

--------------

solve inp = V.modify ((stepM 0) 0) inp
  where 
    stepM s p xs = do
        o <- M.read xs p
        M.write xs 0 (o+inc o)
        where 
          inc o = if o >= 3 then (-1) else 1


main :: IO ()
main = do
    print $ solve $ V.fromList t--input
