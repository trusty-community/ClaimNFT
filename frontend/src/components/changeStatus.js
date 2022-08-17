import React from "react";

export function ChangeStatus({ changeStatus }) {
  return (
    <div>
      <form
        onSubmit={(event) => {
          // This function just calls the transferTokens callback with the
          // form's data.
          event.preventDefault();

          const formData = new FormData(event.target);
          const tokenId = formData.get("tokenId");
          const status = formData.get("status");
          console.log("TokenId ",tokenId);
          console.log("Status ", status);
          if (tokenId && status!="void" ) {
            console.log("Sono nell'IF")
            changeStatus(tokenId, status);
            //mintClaim(to, metadata_url);
          }
        }}
      >
        <div className="form-group">
          <label>TokenID</label>
          <input className="form-control" type="text" name="tokenId" required />
        </div>
        <div className="form-group">
          <select className="form-select form-select-lg mb-3" aria-label="Status Select" name="status" required>
            <option selected value="void">Select a Status</option>
            <option value="ACTIVE">ACTIVE</option>
            <option value="SUSPEND">SUSPEND</option>
            <option value="REVOKE">REVOKE</option>
          </select>
        </div>
        <div className="form-group">
          <input className="btn btn-primary" type="submit" value="changeStatus" />
        </div>
      </form>
    </div>
  );
}
