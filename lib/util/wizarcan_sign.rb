def wizarcan_sign?
  key = "bcbd4a839af6380feb85602151f8d4a0"
  kvs = [params[:activityid],params[:appid],params[:beaconid],params[:ctime],params[:id],params[:openid], params[:otttype],params[:ticket],params[:userinfolevel],key].join
  kvs = Digest::MD5.hexdigest(kvs).upcase 
  kvs == params[:sign].upcase
end