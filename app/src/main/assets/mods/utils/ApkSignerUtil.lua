import "java.io.File"
import "com.mcal.apksigner.ApkSigner"

local _M = {
  v1SigningEnabled = false,
  v2SigningEnabled = false,
  v3SigningEnabled = false,
  runningDirectory = activity.getLuaDir(),
}

_M.pk8File = File(_M.runningDirectory .. "/keys/testkey.pk8")

_M.x509File = File(_M.runningDirectory .. "/keys/testkey.x509.pem")

local function isFile(files)

  return type(files) ~= "string" and files or File(files)

end

_M.getV1SigningEnabled = function()

  return _M.v1SigningEnabled

end

_M.setV1SigningEnabled = function(z)

  _M.v1SigningEnabled = z

end

_M.getV2SigningEnabled = function()

  return _M.v2SigningEnabled

end

_M.setV2SigningEnabled = function(z)

  _M.v2SigningEnabled = z

end

_M.getV3SigningEnabled = function()

  return _M.v3SigningEnabled

end

_M.setV3SigningEnabled = function(z)

  _M.v3SigningEnabled = z

end

_M.getPk8File = function()

  return _M.pk8File

end

_M.setPk8File = function(z)

  _M.v3SigningEnabled = isFile(z)

end

_M.getX509File = function()

  return _M.x509File

end

_M.setX509File = function(z)

  _M.x509File = isFile(z)

end

_M.sign = function()

  local signature_scheme = activity.getSharedData("signature_scheme")

  switch signature_scheme

   case 1

    _M.setV1SigningEnabled(true)

   case 2

    _M.setV2SigningEnabled(true)
 
   case 3
   
   _M.setV3SigningEnabled(true)
   
   default

    _M.setV1SigningEnabled(true)
  
  end

end

_M.signWithDefaultSignature = function(sourceFiles, targetFiles)

  try

    local signer = ApkSigner(isFile(sourceFiles), isFile(targetFiles))

    signer.setUseDefaultSignatureVersion(false)

    if _M.v1SigningEnabled

      signer.setV1SigningEnabled(true)
      signer.setV2SigningEnabled(false)
      signer.setV3SigningEnabled(false)

    end

    if _M.v2SigningEnabled
      signer.setV1SigningEnabled(true)
      signer.setV2SigningEnabled(true)
      signer.setV3SigningEnabled(false)

    end

    if _M.v3SigningEnabled
      signer.setV1SigningEnabled(true)
      signer.setV2SigningEnabled(true)
      signer.setV3SigningEnabled(true)
    end

    signer.signRelease(_M.pk8File, _M.x509File)

    signer = nil

    return true

    catch(e)

    return e

  end

end

return _M