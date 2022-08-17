import React from "react";

export function CheckClaim({ checkClaim }) {
  return (
    <div>
      <form
        onSubmit={(event) => {
          // This function just calls the transferTokens callback with the
          // form's data.
          event.preventDefault();

          const formData = new FormData(event.target);
          const tokenId = formData.get("tokenId");
          //const status = formData.get("status");
          console.log("TokenId ",tokenId);
          //console.log("Status ", status);
          if (tokenId) {
            checkClaim(tokenId);
          }
        }}
      >
        <div className="form-group">
          <label>TokenID</label>
          <input className="form-control" type="text" name="tokenId" required />
        </div>
        <div className="form-group">
          <input className="btn btn-primary" type="submit" value="Check" />
        </div>
      </form>
    </div>
  );
}
