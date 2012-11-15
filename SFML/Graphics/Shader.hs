module SFML.Graphics.Shader
(
    shaderFromFile
,   shaderFromMemory
,   shaderFromStream
,   destroyShader
,   setFloatParameter
,   setFloat2Parameter
,   setFloat3Parameter
,   setFloat4Parameter
,   setVector2Parameter
,   setVector3Parameter
,   setColorParameter
,   setTransformParameter
,   setTextureParameter
,   setCurrentTextureParameter
,   bind
,   isShaderAvailable
)
where


import SFML.Graphics.Color
import SFML.Graphics.Transform
import SFML.Graphics.Types
import SFML.System.InputStream
import SFML.System.Vector2
import SFML.System.Vector3

import Foreign.C.Types
import Foreign.C.String
import Foreign.Marshal.Utils (with)
import Foreign.Ptr


checkNull :: Shader -> Maybe Shader
checkNull shader@(Shader ptr) = if ptr == nullPtr then Nothing else Just shader


-- | Load both the vertex and fragment shaders from files.
--
-- This function can load both the vertex and the fragment
-- shaders, or only one of them: pass 'Nothing' if you don't want to load
-- either the vertex shader or the fragment shader.
--
-- The sources must be text files containing valid shaders
-- in GLSL language. GLSL is a C-like language dedicated to
-- OpenGL shaders; you'll probably need to read a good documentation
-- for it before writing your own shaders.
shaderFromFile
    :: Maybe FilePath -- ^ Path of the vertex shader file to load, or 'Nothing' to skip this shader
    -> Maybe FilePath -- ^ Path of the fragment shader file to load, or 'Nothing' to skip this shader
    -> IO (Maybe Shader)

shaderFromFile  Nothing     Nothing    = fmap checkNull $ sfShader_createFromFile nullPtr nullPtr
shaderFromFile  Nothing    (Just frag) = fmap checkNull . withCString frag $ sfShader_createFromFile nullPtr
shaderFromFile (Just vert)  Nothing    = fmap checkNull . withCString vert $ flip sfShader_createFromFile nullPtr
shaderFromFile (Just vert) (Just frag) = fmap checkNull $
                                     withCString vert $ \cvert ->
                                     withCString frag $ sfShader_createFromFile cvert

foreign import ccall unsafe "sfShader_createFromFile"
    sfShader_createFromFile :: CString -> CString -> IO Shader

-- \return A new sfShader object, or NULL if it failed

--CSFML_GRAPHICS_API sfShader* sfShader_createFromFile(const char* vertexShaderFilename, const char* fragmentShaderFilename);


-- | Load both the vertex and fragment shaders from source codes in memory.
--
-- This function can load both the vertex and the fragment
-- shaders, or only one of them: pass 'Nothing' if you don't want to load
-- either the vertex shader or the fragment shader.
--
-- The sources must be valid shaders in GLSL language. GLSL is
-- a C-like language dedicated to OpenGL shaders; you'll
-- probably need to read a good documentation for it before
-- writing your own shaders.
shaderFromMemory
    :: Maybe String -- ^ String containing the source code of the vertex shader, or 'Nothing' to skip this shader
    -> Maybe String -- ^ String containing the source code of the fragment shader, or 'Nothing' to skip this shader
    -> IO (Maybe Shader)

shaderFromMemory  Nothing     Nothing    = fmap checkNull $ sfShader_createFromMemory nullPtr nullPtr
shaderFromMemory  Nothing    (Just frag) = fmap checkNull . withCString frag $ sfShader_createFromMemory nullPtr
shaderFromMemory (Just vert)  Nothing    = fmap checkNull . withCString vert $ flip sfShader_createFromMemory nullPtr
shaderFromMemory (Just vert) (Just frag) = fmap checkNull $
                                     withCString vert $ \cvert ->
                                     withCString frag $ sfShader_createFromMemory cvert

foreign import ccall unsafe "sfShader_createFromMemory"
    sfShader_createFromMemory :: CString -> CString -> IO Shader

-- \return A new sfShader object, or NULL if it failed

--CSFML_GRAPHICS_API sfShader* sfShader_createFromMemory(const char* vertexShader, const char* fragmentShader);


-- | Load both the vertex and fragment shaders from custom streams.
--
-- This function can load both the vertex and the fragment
-- shaders, or only one of them: pass 'Nothing' if you don't want to load
-- either the vertex shader or the fragment shader.
--
-- The source codes must be valid shaders in GLSL language.
-- GLSL is a C-like language dedicated to OpenGL shaders;
-- you'll probably need to read a good documentation for
-- it before writing your own shaders.
shaderFromStream
    :: Maybe InputStream -- ^ Source stream to read the vertex shader from, or 'Nothing' to skip this shader
    -> Maybe InputStream -- ^ Source stream to read the fragment shader from, or 'Nothing' to skip this shader
    -> IO (Maybe Shader)

shaderFromStream  Nothing     Nothing    = fmap checkNull $ sfShader_createFromStream nullPtr nullPtr
shaderFromStream  Nothing    (Just frag) = fmap checkNull . with frag $ sfShader_createFromStream nullPtr
shaderFromStream (Just vert)  Nothing    = fmap checkNull . with vert $ flip sfShader_createFromStream nullPtr
shaderFromStream (Just vert) (Just frag) = fmap checkNull $
                                     with vert $ \cvert ->
                                     with frag $ sfShader_createFromStream cvert

foreign import ccall unsafe "sfShader_createFromStream"
    sfShader_createFromStream :: Ptr InputStream -> Ptr InputStream -> IO Shader

-- \return A new sfShader object, or NULL if it failed

--CSFML_GRAPHICS_API sfShader* sfShader_createFromStream(sfInputStream* vertexShaderStream, sfInputStream* fragmentShaderStream);


-- | Destroy an existing shader.
destroyShader :: Shader -> IO ()
destroyShader = sfShader_destroy

foreign import ccall unsafe "sfShader_destroy"
    sfShader_destroy :: Shader -> IO ()

--CSFML_GRAPHICS_API void sfShader_destroy(sfShader* shader);


-- | Change a float parameter of a shader.
setFloatParameter
    :: Shader
    -> String -- ^ Name of the parameter in the shader
    -> Float  -- ^ Value to assign
    -> IO ()

setFloatParameter shader name val =
    withCString name $ \cname ->
    sfShader_setFloatParameter shader cname val

foreign import ccall unsafe "sfShader_setFloatParameter"
    sfShader_setFloatParameter :: Shader -> CString -> Float -> IO ()

--CSFML_GRAPHICS_API void sfShader_setFloatParameter(sfShader* shader, const char* name, float x);


-- | Change a 2-components vector parameter of a shader.
setFloat2Parameter
    :: Shader
    -> String -- ^ Name of the parameter in the shader
    -> Float  -- ^ First component of the value to assign
    -> Float  -- ^ Second component of the value to assign
    -> IO ()

setFloat2Parameter shader name f1 f2 =
    withCString name $ \cname ->
    sfShader_setFloat2Parameter shader cname f1 f2

foreign import ccall unsafe "sfShader_setFloat2Parameter"
    sfShader_setFloat2Parameter :: Shader -> CString -> Float -> Float -> IO ()

--CSFML_GRAPHICS_API void sfShader_setFloat2Parameter(sfShader* shader, const char* name, float x, float y);


-- | Change a 3-components vector parameter of a shader.
setFloat3Parameter
    :: Shader
    -> String -- ^ Name of the parameter in the shader
    -> Float  -- ^ First component of the value to assign
    -> Float  -- ^ Second component of the value to assign
    -> Float  -- ^ Third component of the value to assign
    -> IO ()

setFloat3Parameter shader name f1 f2 f3 =
    withCString name $ \cname ->
    sfShader_setFloat3Parameter shader cname f1 f2 f3

foreign import ccall unsafe "sfShader_setFloat3Parameter"
    sfShader_setFloat3Parameter :: Shader -> CString -> Float -> Float -> Float -> IO ()

--CSFML_GRAPHICS_API void sfShader_setFloat3Parameter(sfShader* shader, const char* name, float x, float y, float z);


-- | Change a 4-components vector parameter of a shader.
setFloat4Parameter
    :: Shader
    -> String -- ^ Name of the parameter in the shader
    -> Float  -- ^ First component of the value to assign
    -> Float  -- ^ Second component of the value to assign
    -> Float  -- ^ Third component of the value to assign
    -> Float  -- ^ Fourth component of the value to assign
    -> IO ()

setFloat4Parameter shader name f1 f2 f3 f4 =
    withCString name $ \cname ->
    sfShader_setFloat4Parameter shader cname f1 f2 f3 f4

foreign import ccall unsafe "sfShader_setFloat4Parameter"
    sfShader_setFloat4Parameter :: Shader -> CString -> Float -> Float -> Float -> Float -> IO ()

--CSFML_GRAPHICS_API void sfShader_setFloat4Parameter(sfShader* shader, const char* name, float x, float y, float z, float w);


-- | Change a 2-components vector parameter of a shader.
setVector2Parameter
    :: Shader
    -> String -- ^ Name of the parameter in the shader
    -> Vec2f  -- ^ Vector to assign
    -> IO ()

setVector2Parameter shader name vec =
    withCString name $ \cname ->
    with vec $ sfShader_setVector2Parameter_helper shader cname

foreign import ccall unsafe "sfShader_setVector2Parameter_helper"
    sfShader_setVector2Parameter_helper :: Shader -> CString -> Ptr Vec2f -> IO ()

--CSFML_GRAPHICS_API void sfShader_setVector2Parameter(sfShader* shader, const char* name, sfVector2f vector);


-- | Change a 3-components vector parameter of a shader.
setVector3Parameter
    :: Shader
    -> String -- ^ Name of the parameter in the shader
    -> Vec3f  -- ^ Vector to assign
    -> IO ()

setVector3Parameter shader name vec =
    withCString name $ \cname ->
    with vec $ sfShader_setVector3Parameter_helper shader cname

foreign import ccall unsafe "sfShader_setVector3Parameter_helper"
    sfShader_setVector3Parameter_helper :: Shader -> CString -> Ptr Vec3f -> IO ()    

--CSFML_GRAPHICS_API void sfShader_setVector3Parameter(sfShader* shader, const char* name, sfVector3f vector);


-- | Change a color parameter of a shader.
setColorParameter
    :: Shader
    -> String -- ^ Name of the parameter in the shader
    -> Color  -- ^ Color to assign
    -> IO ()

setColorParameter shader name color =
    withCString name $ \cname ->
    with color $ sfShader_setColorParameter_helper shader cname

foreign import ccall unsafe "sfShader_setColorParameter_helper"
    sfShader_setColorParameter_helper :: Shader -> CString -> Ptr Color -> IO ()

--CSFML_GRAPHICS_API void sfShader_setColorParameter(sfShader* shader, const char* name, sfColor color);


-- | Change a matrix parameter of a shader.
setTransformParameter
    :: Shader
    -> String    -- ^ Name of the parameter in the shader
    -> Transform -- ^ Transform to assign
    -> IO ()

setTransformParameter shader name transf =
    withCString name $ \cname ->
    with transf $ sfShader_setTransformParameter_helper shader cname

foreign import ccall unsafe "sfShader_setTransformParameter_helper"
    sfShader_setTransformParameter_helper :: Shader -> CString -> Ptr Transform -> IO ()

--CSFML_GRAPHICS_API void sfShader_setTransformParameter(sfShader* shader, const char* name, sfTransform transform);


-- | Change a texture parameter of a shader.
--
-- The corresponding parameter in the shader must be a 2D texture (sampler2D GLSL type).
setTextureParameter
    :: Shader
    -> String  -- ^ Name of the texture in the shader
    -> Texture -- ^ Texture to assign
    -> IO ()

setTextureParameter shader name tex =
    withCString name $ \cname -> sfShader_setTextureParameter shader cname tex

foreign import ccall unsafe "sfShader_setTextureParameter"
    sfShader_setTextureParameter :: Shader -> CString -> Texture -> IO ()

--CSFML_GRAPHICS_API void sfShader_setTextureParameter(sfShader* shader, const char* name, const sfTexture* texture);


-- | Change a texture parameter of a shader.
--
-- This function maps a shader texture variable to the
-- texture of the object being drawn, which cannot be
-- known in advance.
--
-- The corresponding parameter in the shader must be a 2D texture
-- (sampler2D GLSL type).
setCurrentTextureParameter
    :: Shader
    -> String -- ^ Name of the texture in the shader
    -> IO ()

setCurrentTextureParameter shader name = withCString name $ sfShader_setCurrentTextureParameter shader

foreign import ccall unsafe "sfShader_setCurrentTextureParameter"
    sfShader_setCurrentTextureParameter :: Shader -> CString -> IO ()

--CSFML_GRAPHICS_API void sfShader_setCurrentTextureParameter(sfShader* shader, const char* name);


-- | Bind a shader for rendering (activate it)
--
-- This function is normally for internal use only, unless
-- you want to use the shader with a custom OpenGL rendering
-- instead of a SFML drawable.
bind :: Shader -> IO ()
bind = sfShader_bind

foreign import ccall unsafe "sfShader_bind"
    sfShader_bind :: Shader -> IO ()

--CSFML_GRAPHICS_API void sfShader_bind(const sfShader* shader);


-- | Tell whether or not the system supports shaders.
--
-- This function should always be called before using
-- the shader features. If it returns 'False', then
-- any attempt to use 'Shader' will fail.
isShaderAvailable :: IO Bool
isShaderAvailable = fmap (toEnum . fromIntegral) sfShader_isAvailable

foreign import ccall unsafe "sfShader_isAvailable"
    sfShader_isAvailable :: IO CInt

--CSFML_GRAPHICS_API sfBool sfShader_isAvailable(void);

